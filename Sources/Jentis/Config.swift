import Foundation

struct Config {
    static let keyPrefix = "at.allaboutapps"
    
    enum Const {
        public static let os = "iOS"
    }
    
    enum Tracking {
        static let idLength = 23
        static let pluginId = "jts_push_submit"
        static let sessionDuration = 30
    }
    
    enum Action: String {
        case udp, new
    }
    
    enum DocumentType: String {
        case user, session, event
    }
}
