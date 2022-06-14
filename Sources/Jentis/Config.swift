import Foundation

public struct Config {
    static let keyPrefix = "at.allaboutapps"
    
    public enum Const {
        public static let os = "iOS"
    }
    
    public enum Tracking {
        static let idLength = 23
        static let pluginId = "jts_push_submit"
        static let sessionDuration = 30
    }
    
    public enum Action: String {
        case udp, new
    }
    
    public enum DocumentType: String {
        case user, session, event
    }
}
