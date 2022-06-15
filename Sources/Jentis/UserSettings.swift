import Foundation

class UserSettings {
    enum Keys {
        static let userId = Config.keyPrefix + ".userId"
        static let consents = Config.keyPrefix + ".consents"
    }

    static let shared = UserSettings()
    private let defaults = UserDefaults.standard

    private init() {}

    func getUserId() -> String? {
        defaults.object(forKey: UserSettings.Keys.userId) as? String
    }

    func setUserID(userId: String) {
        defaults.set(userId, forKey: UserSettings.Keys.userId)
    }

    func getConsents() -> [String: Bool]? {
        defaults.object(forKey: UserSettings.Keys.userId) as? [String: Bool]
    }

    func setConsents(consents: [String: Bool]) {
        defaults.set(consents, forKey: UserSettings.Keys.consents)
    }
}
