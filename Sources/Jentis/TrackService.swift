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
    private var trackingEnabled: Bool = true
    private var debugInfo: DebugInformation?
    private var userId: String
    private var sessionId: String
    private var sessionCreatedAt: Date

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
    /// - Parameter consents: A list of the new Consents with true/false
    public func setConsents(consents: [String: Bool]) {
        let previousConsents = UserSettings.shared.getConsents()
        let consentId = UserSettings.shared.getConsentId() ?? UUID().uuidString
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
        
        API.shared.setConsentSettings(consentSettings)
    }

    /// Enable tracking
    public func enableTracking() {
        guard config != nil else {
            print("[JENTIS] Call initTracking first")
            return
        }

        trackingEnabled = true
        print("[JENTIS] Tracking enabled")
    }

    /// Disable tracking
    public func disableTracking() {
        guard config != nil else {
            print("[JENTIS] Call initTracking first")
            return
        }

        trackingEnabled = false
        print("[JENTIS] Tracking disabled")
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

    /// Track the default parameters
    ///
    /// - Parameter currentView: (optional) Pass the current View to the tracking
    public func trackDefault(currentView: String? = nil) {
        guard trackingEnabled else {
            print("[JENTIS] Tracking is disabled")
            return
        }

        guard config != nil else {
            print("[JENTIS] Call initTracking first")
            return
        }

        guard let trackingData = getTrackingData(currentView: currentView) else {
            print("[JENTIS] Error - Failed to get tracking data")
            return
        }

        if !isSessionValid() {
            sessionId = String.randomId()
        }

        API.shared.trackDefault(trackingData)
    }

    // TODO: Implement
    /// Track custom Parameters
    public func trackCustom() {
        guard trackingEnabled else {
            print("[JENTIS] Tracking is disabled")
            return
        }

        guard config != nil else {
            print("[JENTIS] Call initTracking first")
            return
        }
    }

    // MARK: Private functions

    func getTrackingData(currentView: String? = nil) -> TrackingData? {
        let trackingData = TrackingData()

        let parent = Parent()
        parent.user = userId
        parent.session = sessionId

        trackingData.client = getClient()
        trackingData.data.append(getUserData(parent: parent))
        trackingData.data.append(getSessionData(parent: parent))
        trackingData.data.append(getEventData(parent: parent, currentView: currentView))

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
        // top VC
        let topVC = UIApplication.topViewController()

        let topVVName = NSStringFromClass(topVC!.classForCoder)

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

        sessionData.property = sessionDataProperty

        sessionData.parent = parent

        return sessionData
    }

    func getEventData(parent: Parent, currentView _: String? = nil) -> TrackingDataDatum {
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
        eventDataProperty.jtspushedcommands = ["pageview",
                                               "submit"]
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
