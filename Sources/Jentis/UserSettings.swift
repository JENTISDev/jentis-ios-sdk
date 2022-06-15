import Foundation

class UserSettings {
    enum Keys {
        static let userId = Config.keyPrefix + ".userId"
        static let consents = Config.keyPrefix + ".consents"
        static let consentId = Config.keyPrefix + ".consentId"
        static let lastConsentUpdate = Config.keyPrefix + ".lastConsentUpdate"
    }

    static let shared = UserSettings()
    private let defaults = UserDefaults.standard

    private init() {}

    func getUserId() -> String? {
        defaults.object(forKey: UserSettings.Keys.userId) as? String
    }

    func setUserID(_ userId: String) {
        defaults.set(userId, forKey: UserSettings.Keys.userId)
    }

    func getConsents() -> [String: Bool]? {
        defaults.object(forKey: UserSettings.Keys.consents) as? [String: Bool]
    }

    func setConsents(_ consents: [String: Bool]) {
        defaults.set(consents, forKey: UserSettings.Keys.consents)
    }
    
    func getConsentId() -> String? {
        defaults.object(forKey: UserSettings.Keys.consentId) as? String
    }
    
    func setConsentId(_ consentId: String) {
        defaults.set(consentId, forKey: UserSettings.Keys.consentId)
    }
    
    func getLastConsentUpdate() -> Int64? {
        defaults.object(forKey: UserSettings.Keys.lastConsentUpdate) as? Int64
    }
    
    func setLastConsentUpdate(timestamp: Int64) {
        defaults.set(timestamp, forKey: UserSettings.Keys.lastConsentUpdate)
    }
}
