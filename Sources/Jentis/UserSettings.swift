//
//  File.swift
//  
//
//  Created by Andreas Mühleder on 14.06.22.
//

import Foundation

class UserSettings {
    enum Keys {
        static let userId = Config.keyPrefix + ".userId"
    }
    
    static let shared = UserSettings()
    private let defaults = UserDefaults.standard

    private init() {}
    
    func getUserId() -> String? {
        return defaults.object(forKey: UserSettings.Keys.userId) as? String
    }
    
    func setUserID(userId: String) {
        defaults.set(userId, forKey: UserSettings.Keys.userId)
    }
}
