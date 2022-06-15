import Foundation
import UIKit

// MARK: DebugInformation

struct DebugInformation {
    var debugEnabled: Bool
    var debugId: String?
    var version: String?
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

    // FIXME: Todo
    public func getConsentId() -> String? {
        UserSettings.shared.getConsentId()
    }

    /// Set new consent values
    /// Trackings which were stored previously (while consent was nil) are sent automatically (if at least one tracking provider is enabled)
    /// - Parameter consents: A list of the new Consents with true/false
    public func setConsents(consents: [String: Bool]) {
        let previousConsents = UserSettings.shared.getConsents()
        let consentId = UserSettings.shared.getConsentId() ?? UUID().uuidString.lowercased()
        UserSettings.shared.setConsentId(consentId)

        var diffDict: [String: Bool] = [:]
        if let previousConsents = previousConsents {
            for previousConsent in previousConsents {
                if previousConsents[previousConsent.key] != consents[previousConsent.key] {
                    diffDict[previousConsent.key] = consents[previousConsent.key]
                }
            }
        }

        self.consents = consents
        UserSettings.shared.setConsents(consents)

        sendConsentSettings(consentId: consentId, vendors: consents, vendorsChanged: diffDict)
    }

    private func sendConsentSettings(consentId: String, vendors: [String: Bool], vendorsChanged: [String: Bool]) {
        var consentSettings: [TrackingDataDatum] = []

        let parent = Parent()
        parent.user = userId
        parent.session = sessionId

        consentSettings.append(getUserData(parent: parent))
        consentSettings.append(getConsentData(parent: parent, consentId: consentId, vendors: vendors, vendorsChanged: vendorsChanged))

        // FIXME: Remove
        let jsonData = try! JSONEncoder().encode(consentSettings)
        let jsonString = String(data: jsonData, encoding: .utf8)!

        API.shared.setConsentSettings(consentSettings) { [weak self] in
            guard let self = self else {
                return
            }
            
            if self.isTrackingDisabled() {
                // User disabled all Tracking options - discard tracking
                self.storedTrackings = []
                return
            }

            let currentlyStoredTrackings = self.storedTrackings
            
            for storedTracking in currentlyStoredTrackings {
                API.shared.submitTracking(storedTracking) {}
            }
            
            self.storedTrackings = []
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

    /// Send a tracking
    /// - if no consent was set until now, the tracking is stored until a consent is set / the app is closed
    /// - if the consent was set but all trackingproviders are disabled the tracking is discarded
    /// - if the consent was set and at least one trackingprovider is enabled -> tracking is sent to the server
    ///
    /// - Parameter data: Contains the key:value pairs
    public func push(data: [String: Any]) {
        if isTrackingDisabled() {
            // User disabled all Tracking options - discard tracking
            currentTracks = []
            currentProperties = [:]
            return
        }

        guard let trackString = data[Config.Tracking.trackKey] as? String else {
            print("[JENTIS] track not included")
            return
        }

        currentTracks.append(trackString)

        for entry in data {
            if entry.key != Config.Tracking.trackKey {
                currentProperties[entry.key] = entry.value
            }
        }

        if trackString == Config.Tracking.Track.submit.rawValue {
            guard config != nil else {
                print("[JENTIS] Call initTracking first")
                return
            }

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

                let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: [])

                if var dictionary = jsonDict as? [String: Any] {
                    if var data = dictionary[Config.Tracking.dataKey] as? [[String: Any]] {
                        if let index = data.firstIndex(where: { $0.contains(where: { $0.key == Config.Tracking.documentTypeKey && $0.value as? String == Config.DocumentType.event.rawValue }) }) {
                            var eventDocument = data[index]
                            if var eventProperties = eventDocument[Config.Tracking.propertiesKey] as? [String: Any] {
                                for customProperty in currentProperties {
                                    eventProperties[customProperty.key] = customProperty.value
                                }

                                eventDocument[Config.Tracking.propertiesKey] = eventProperties
                                data[index] = eventDocument
                                dictionary["data"] = data

                                if let modifiedJsonData = try? JSONSerialization.data(withJSONObject: dictionary) {
                                    currentProperties = [:]
                                    currentTracks = []

                                    // Consents not set yet
                                    // Storing current tracking
                                    if consents == nil {
                                        storedTrackings.append(modifiedJsonData)
                                    } else {
                                        API.shared.submitTracking(modifiedJsonData) {}
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
                print(error)
            }
        }
    }

    // MARK: Private functions

    func getTrackingData() -> TrackingData? {
        let trackingData = TrackingData()

        let parent = Parent()
        parent.user = userId
        parent.session = sessionId

        trackingData.client = getClient()
        trackingData.data.append(getUserData(parent: parent))
        trackingData.data.append(getSessionData(parent: parent))
        trackingData.data.append(getEventData(parent: parent))

        // FIXME: Remove
        let jsonData = try! JSONEncoder().encode(trackingData)
        let jsonString = String(data: jsonData, encoding: .utf8)!

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

        consentData.account = "\(config!.trackID).\(config!.environment.rawValue)"

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
        userData.action = Config.Action.udp.rawValue
        userData.account = "\(config!.trackID).\(config!.environment.rawValue)"
        userData.documentType = Config.DocumentType.user.rawValue
        userData.system = System()

        return userData
    }

    func getSessionData(parent: Parent) -> TrackingDataDatum {
        let sessionData = TrackingDataDatum()
        sessionData.id = parent.session
        sessionData.action = Config.Action.udp.rawValue
        sessionData.account = "\(config!.trackID).\(config!.environment.rawValue)"

        // Screen Size
        let screenSize: CGRect = UIScreen.main.bounds
        // iOS Version
        let systemVersion = UIDevice.current.systemVersion
        // Language
        let languageCode = Locale.current.languageCode

        let sessionDataProperty = Property()
        sessionData.documentType = Config.DocumentType.session.rawValue
        sessionDataProperty.navigatorLanguage = languageCode
        sessionDataProperty.navigatorPlatform = Config.Const.os
        sessionDataProperty.windowScreenWidth = Int(screenSize.width)
        sessionDataProperty.windowScreenHeight = Int(screenSize.height)
        sessionDataProperty.windowViewportHeight = Int(screenSize.height)
        sessionDataProperty.windowViewportWidth = Int(screenSize.width)
        sessionDataProperty.navigatorUseragent = systemVersion

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

        eventData.account = "\(config!.trackID).\(config!.environment.rawValue)"

        let eventDataSystem = System()
        eventDataSystem.consent = consents
        eventDataSystem.href = ""
        eventData.system = eventDataSystem

        let eventDataProperty = Property()
        eventDataProperty.jtspushedcommands = currentTracks
        currentTracks = []
        eventDataProperty.userDocID = userId
        eventDataProperty.eventDocID = eventId

        eventData.property = eventDataProperty

        return eventData
    }

    func getClient() -> Client {
        let client = Client()

        client.clientTimestamp = Date().millisecondsSince1970

        // Use App Name for Domain
        client.domain = "\(config!.trackDomain).\(Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "")"

        return client
    }

    func isSessionValid() -> Bool {
        // The session should be valid for 30 minutes
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
        
        return !consents.values.contains(where: { $0 })
    }

    func getTestTrackingData() -> TrackingData? {
        guard let url = Bundle.module.url(forResource: "testTrackingData", withExtension: "json") else {
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(TrackingData.self, from: data)
        } catch {
            print("Error - Unable to parse  testjson")
            return nil
        }
    }
}
