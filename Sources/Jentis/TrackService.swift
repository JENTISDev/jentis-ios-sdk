import Foundation
import UIKit

// MARK: DebugInformation

struct DebugInformation {
    var debugEnabled: Bool
    var debugId: String?
    var version: String?
}

public enum JentisError: Error {
    case setConsentError
    case requestError
}

// MARK: TrackService

/// The service which manages the tracking to Jentis
public class TrackService {
    // MARK: Variables

    /// The singleton instance of TrackService
    public static let shared = TrackService()

    private var config: TrackConfig?
    private var consents: [String: Bool]?
    private var debugInfo: DebugInformation?
    private var userId: String
    private var sessionId: String
    private var sessionCreatedAt: Date
    private var currentTracks: [String] = []
    private var currentProperties: [String: Any?] = [:]
    private var storedTrackings: [Data] = []
    
    /// Product track
    var productDictionary = [String: [Any]]()
    var productCounter = 0

    // MARK: Initializer

    private init() {
        // Load userId from UserDefaults
        // Generate userId if it does not exist
        if let userId = UserSettings.shared.getUserId() {
            self.userId = userId
        } else {
            userId = String.randomId()
            UserSettings.shared.setUserID(userId)
        }

        sessionId = String.randomId()
        sessionCreatedAt = Date()
    }

    // MARK: Public functions

    /// Initializes the Jentis Tracking in the SDK
    ///
    /// - Parameter config: Contains the Configuration to initialize the SDK
    public func initTracking(config: TrackConfig) {
        if let consent = UserSettings.shared.getConsents() {
            consents = consent
        }

        self.config = config
        API.shared.setup(baseUrl: config.trackDomain)
    }

    /// Get the current consent settings
    /// - Returns: A list of the current consents with true/false
    public func getCurrentConsents() -> [String: Bool]? {
        consents
    }

    /// Get the current consent ID
    /// - Returns: The current consent ID if it was created already
    public func getConsentId() -> String? {
        UserSettings.shared.getConsentId()
    }

    /// Get the date of the last consent update
    /// - Returns: The last consent update Date
    public func getLastConsentUpdate() -> Date? {
        if let lastConsentUpdate = UserSettings.shared.getLastConsentUpdate() {
            let timestamp = TimeInterval(integerLiteral: lastConsentUpdate / 1000)
            let date = Date(timeIntervalSince1970: timestamp)
            return date
        }
        return nil
    }

    /// Set new consent values
    /// Trackings which were stored previously (while consent was nil) are sent automatically (if at least one tracking provider is enabled)
    /// - Parameter consents: A list of the new Consents with true/false
    /// - Parameter completion: Contains the information whether the request was successful or not
    public func setConsents(consents: [String: Bool], completion: @escaping (Result<Void, JentisError>) -> Void) {
        guard config != nil else {
            print("[JENTIS] Call initTracking first")
            completion(.failure(.setConsentError))
            return
        }

        let previousConsents = UserSettings.shared.getConsents()
        let consentId = UserSettings.shared.getConsentId() ?? UUID().uuidString.lowercased()

        // Get changed Vendors List
        var vendorsChanged: [String: Bool] = [:]
        if let previousConsents = previousConsents {
            for previousConsent in previousConsents {
                if previousConsents[previousConsent.key] != consents[previousConsent.key] {
                    vendorsChanged[previousConsent.key] = consents[previousConsent.key]
                    
                }
            }
        }

        sendConsentSettings(consentId: consentId, vendors: consents, vendorsChanged: vendorsChanged, completion: completion)
    }

    /// Set new consent values
    /// Trackings which were stored previously (while consent was nil) are sent automatically (if at least one tracking provider is enabled)
    /// - Parameter consents: A list of the new Consents with true/false
    public func setConsents(consents: [String: Bool]) async -> Result<Void, JentisError> {
        return await withCheckedContinuation { continuation in
            setConsents(consents: consents) { result in
                continuation.resume(returning: result)
            }
        }
    }

    /// Set debugging of tracking
    ///
    /// - Parameter shouldDebug: Bool to activate/deactivate debugging
    /// - Parameter debugId: (optional) Set the ID when enabling debugging
    /// - Parameter version: (otpional) Set the version when enabling debugging
    public func debugTracking(_ shouldDebug: Bool, debugId: String? = nil, version: String? = nil) {
        guard config != nil else {
            print("[JENTIS] Call initTracking first")
            return
        }

        if shouldDebug {
            guard let debugId = debugId, let version = version else {
                print("[JENTIS] Set debugId & version to debug")
                return
            }

            debugInfo = DebugInformation(debugEnabled: shouldDebug, debugId: debugId, version: version)
        } else {
            debugInfo = DebugInformation(debugEnabled: shouldDebug)
        }
    }

    /// Tracking method
    /// - if no consent was set until now, the tracking is stored until a consent is set / the app is closed
    /// - if the consent was set but all trackingproviders are disabled the tracking is discarded
    /// - if the consent was set and at least one trackingprovider is enabled -> tracking is sent to the server
    ///
    /// - Parameter data: Contains the key:value pairs
    public func push(data: [String: Any]) {
        guard config != nil else {
            print("[JENTIS] Call initTracking first")
            return
        }

        if isTrackingDisabled() {
            // User disabled all Tracking options - discard tracking
            currentTracks = []
            currentProperties = [:]
            print("[JENTIS]: not tracking - all vendors are set to false")
            return
        }

        guard let trackString = data[Config.Tracking.trackKey] as? String else {
            print("[JENTIS] track not included")
            return
        }

        if trackString == Config.Tracking.Track.product.rawValue {
            for entry in data {
                if entry.key != Config.Tracking.trackKey {
                    if productDictionary.contains(where: { $0.key == entry.key }) {
                        productDictionary[entry.key]?.append(entry.value)
                    } else {
                        productDictionary[entry.key] = []
                        for i in 0 ... productCounter {
                            if i == productCounter { break }
                            productDictionary[entry.key]?.append("")
                        }

                        productDictionary[entry.key]?.append(entry.value)
                    }
                }
            }
            productCounter += 1

            for (key, value) in productDictionary where value.count < productCounter {
                productDictionary[key]?.append("")
            }
        }

        currentTracks.append(trackString)

        for entry in data {
            if entry.key != Config.Tracking.trackKey {
                currentProperties[entry.key] = entry.value
            }
        }

        if trackString == Config.Tracking.Track.submit.rawValue {
            submitPush()
        }
    }

    // MARK: Private functions

    private func sendConsentSettings(consentId: String, vendors: [String: Bool], vendorsChanged: [String: Bool], completion: @escaping (Result<Void, JentisError>) -> Void) {

        if !isSessionValid() {
            sessionId = String.randomId()
        }

        let trackingData = JentisData()

        let parent = Parent()
        parent.user = userId
        parent.session = sessionId

        trackingData.client = getClient()
        trackingData.data.append(getUserData(parent: parent))
        trackingData.data.append(getConsentData(parent: parent, consentId: consentId, vendors: vendors, vendorsChanged: vendorsChanged))

        API.shared.setConsentSettings(trackingData) { [weak self] result in
            guard let self = self else {
                return
            }

            completion(result)

            switch result {
            case .success:
                self.consents = vendors
                UserSettings.shared.setConsents(vendors)
                UserSettings.shared.setConsentId(consentId)
            case .failure:
                return
            }

            if self.isTrackingDisabled() {
                // User disabled all Tracking options - discard tracking
                self.storedTrackings = []
                print("[JENTIS]: clearing stored trackings - all vendors are set to false")
                return
            }

            // User set consents - send stored trackings
            let currentlyStoredTrackings = self.storedTrackings

            for storedTracking in currentlyStoredTrackings {
                API.shared.submitTracking(storedTracking) { _ in }
            }

            self.storedTrackings = []
        }
    }

    private func submitPush() {
        if !isSessionValid() {
            sessionId = String.randomId()
        }

        guard let trackingData = getTrackingData() else {
            print("[JENTIS] Error - Failed to get tracking data")
            return
        }

        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(trackingData)

            // Tracking Data as Dictionary
            let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: [])

            if var dictionary = jsonDict as? [String: Any] {
                // Get data from Tracking Data
                if var data = dictionary[Config.Tracking.dataKey] as? [[String: Any]] {
                    // Get index of event document
                    if let index = data.firstIndex(where: { $0.contains(where: { $0.key == Config.Tracking.documentTypeKey && $0.value as? String == Config.DocumentType.event.rawValue }) }) {
                        var eventDocument = data[index]

                        // Get Properties of event document
                        if var eventProperties = eventDocument[Config.Tracking.propertiesKey] as? [String: Any] {
                            // Append custom properties
                            for customProperty in currentProperties {
                                eventProperties[customProperty.key] = customProperty.value
                            }
                            
                            for (key, value) in productDictionary {
                                eventProperties[key] = value
                            }
                            
                            // Override event document with custom properties included
                            eventDocument[Config.Tracking.propertiesKey] = eventProperties
                            data[index] = eventDocument
                            dictionary[Config.Tracking.dataKey] = data

                            // Get data from new dictionary
                            if let modifiedJsonData = try? JSONSerialization.data(withJSONObject: dictionary) {
                                currentProperties = [:]
                                currentTracks = []
                                productDictionary.removeAll()
                                productCounter = 0

                                if consents == nil {
                                    // Consents not set yet
                                    // Storing current tracking

                                    print("[JENTIS]: Consent not set yet, storing tracking")
                                    storedTrackings.append(modifiedJsonData)
                                } else {
                                    print("[JENTIS]: Sending tracking")
                                    API.shared.submitTracking(modifiedJsonData) { _ in }
                                }
                            }
                        }
                    } else {
                        print("[JENTIS] Failed to get index of event document")
                    }
                } else {
                    print("[JENTIS] Failed to get data from json dict")
                }
            } else {
                print("[JENTIS] Failed to parse json dictionary")
            }
        } catch {
            print("[JENTIS] Error: \(error)")
        }
    }

    func getTrackingData() -> JentisData? {
        let trackingData = JentisData()

        let parent = Parent()
        parent.user = userId
        parent.session = sessionId

        trackingData.client = getClient()
        trackingData.data.append(getUserData(parent: parent))
        trackingData.data.append(getSessionData(parent: parent))
        trackingData.data.append(getEventData(parent: parent))

        return trackingData
    }

    func getConsentData(parent: Parent, consentId: String, vendors: [String: Bool], vendorsChanged: [String: Bool]) -> TrackingDataDatum {
        let timestamp = Date().millisecondsSince1970

        UserSettings.shared.setLastConsentUpdate(timestamp: timestamp)

        let consentData = TrackingDataDatum()
        consentData.id = String.randomId()
        consentData.documentType = Config.DocumentType.consent.rawValue

        consentData.action = Config.Action.new.rawValue

        let consentDataParent = Parent()
        consentDataParent.user = parent.user
        consentData.parent = consentDataParent

        consentData.account = getAccount()

        let consentDataProperty = Property()
        consentDataProperty.track = Config.Tracking.Track.consent.rawValue
        consentDataProperty.consentid = consentId
        consentDataProperty.lastupdate = timestamp
        consentDataProperty.vendors = vendors
        consentDataProperty.send = true
        consentDataProperty.userconsent = true
        consentDataProperty.vendorsChanged = vendorsChanged
        consentData.property = consentDataProperty

        return consentData
    }

    func getUserData(parent: Parent) -> TrackingDataDatum {
        let userData = TrackingDataDatum()
        userData.id = parent.user
        userData.action = Config.Action.upd.rawValue
        userData.account = getAccount()
        userData.documentType = Config.DocumentType.user.rawValue

        let userDataSystem = System()
        userDataSystem.environment = Config.Tracking.systemEnvironment
        userData.system = userDataSystem

        return userData
    }

    func getSessionData(parent: Parent) -> TrackingDataDatum {
        let sessionData = TrackingDataDatum()
        sessionData.id = parent.session
        sessionData.action = Config.Action.upd.rawValue
        sessionData.account = getAccount()
        sessionData.documentType = Config.DocumentType.session.rawValue

        let sessionDataProperty = Property()

        if let debugInfo = debugInfo, debugInfo.debugEnabled {
            sessionDataProperty.jtsDebug = debugInfo.debugId
            sessionDataProperty.jtsVersion = debugInfo.version
        }

        sessionData.system = System()
        sessionData.property = sessionDataProperty

        sessionData.parent = parent

        return sessionData
    }

    func getEventData(parent: Parent) -> TrackingDataDatum {
        let eventData = TrackingDataDatum()
        let eventId = String.randomId()
        eventData.id = eventId
        eventData.documentType = Config.DocumentType.event.rawValue
        eventData.action = Config.Action.new.rawValue

        eventData.parent = parent
        eventData.pluginid = Config.Tracking.pluginId

        eventData.account = getAccount()

        let eventDataSystem = System()
        eventDataSystem.consent = consents
        eventDataSystem.href = ""
        eventData.system = eventDataSystem

        let screenSize: CGRect = UIScreen.main.bounds
        let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String

        let eventDataProperty = Property()
        eventDataProperty.jtspushedcommands = currentTracks
        currentTracks = []
        eventDataProperty.userDocID = userId
        eventDataProperty.eventDocID = eventId
        eventDataProperty.appDeviceBrand = Config.Device.brand
        eventDataProperty.appDeviceModel = String.deviceModel
        eventDataProperty.appDeviceOS = Config.Device.os
        eventDataProperty.appDeviceOSVersion = UIDevice.current.systemVersion
        eventDataProperty.appDeviceLanguage = Locale.current.languageCode
        eventDataProperty.appDeviceRegion = NSLocale.current.regionCode
        eventDataProperty.appDeviceWidth = Int(screenSize.width)
        eventDataProperty.appDeviceHeight = Int(screenSize.height)
        eventDataProperty.appApplicationName = appName
        eventDataProperty.appApplicationVersion = appVersion
        eventDataProperty.appApplicationBuildNumber = buildNumber

        eventData.property = eventDataProperty

        return eventData
    }

    func getClient() -> Client {
        let client = Client()

        client.clientTimestamp = Date().millisecondsSince1970

        let trackDomain = ".\(config!.trackDomain.deletingPrefix(Config.Tracking.trackingDomainPrefix))"

        client.domain = trackDomain

        return client
    }

    private func getAccount() -> String {
        guard let config = config else {
            return ""
        }

        return "\(config.trackID).\(config.environment.rawValue)"
    }

    func isSessionValid() -> Bool {
        // Check if the session is not longer valid then the specified session duration
        if let diff = Calendar.current.dateComponents([.minute], from: sessionCreatedAt, to: Date()).minute, diff < Config.Tracking.sessionDuration {
            return true
        } else {
            return false
        }
    }

    func isTrackingDisabled() -> Bool {
        guard let consents = consents else {
            return false
        }

        // Check if any vendor is set to true
        return !consents.values.contains(where: { $0 })
    }
}
