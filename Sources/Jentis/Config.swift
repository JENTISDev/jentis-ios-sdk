import Foundation

struct Config {
    static let keyPrefix = "at.allaboutapps"
    
    enum Device {
        public static let os = "iOS"
        public static let brand = "Apple"
    }
    
    enum Tracking {
        static let idLength = 23
        static let pluginId = "jts_push_submit"
        static let sessionDuration = 30
        static let trackKey = "track"
        static let dataKey = "data"
        static let documentTypeKey = "documentType"
        static let propertiesKey = "property"
        static let productKey = "product"
        static let systemEnvironment = "sdk-ios"
        static let trackingDomainPrefix = "https://"
        
        enum Track: String {
            case consent, pageview, submit, product
        }
    }
    
    enum Action: String {
        case upd, new
    }
    
    enum DocumentType: String {
        case user, session, event, consent
    }
}
