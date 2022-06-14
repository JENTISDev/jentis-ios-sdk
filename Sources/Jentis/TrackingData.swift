import Foundation

// MARK: - TrackingData

class TrackingData: Codable {
    var client: Client?
    var cmd: Cmd = Cmd()
    var data: [TrackingDataDatum] = []

    init() {}

    init(client: Client?, cmd: Cmd?, data: [TrackingDataDatum]?) {
        self.client = client
        self.cmd = cmd ?? Cmd()
        self.data = data ?? []
    }
}

// MARK: - Client

class Client: Codable {
    var clientTimestamp: Int?
    var domain: String?
    
    init() {}

    init(clientTimestamp: Int?, domain: String?) {
        self.clientTimestamp = clientTimestamp
        self.domain = domain
    }
}

// MARK: - Cmd

class Cmd: Codable {
    var key: String?
    var data: [CmdDatum]?
    
    init() {}

    init(key: String?, data: [CmdDatum]?) {
        self.key = key
        self.data = data
    }
}

// MARK: - CmdDatum

class CmdDatum: Codable {
    var name, value: String?
    var exdays: Int?
    var pluginids: [String]?
    
    init() {}

    init(name: String?, value: String?, exdays: Int?, pluginids: [String]?) {
        self.name = name
        self.value = value
        self.exdays = exdays
        self.pluginids = pluginids
    }
}

// MARK: - TrackingDataDatum

class TrackingDataDatum: Codable {
    var id, action, account, documentType: String?
    var property: Property = Property()
    var system: System = System()
    var aggr: Aggr = Aggr()
    var parent: Parent = Parent()
    var pluginid: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case action, account, documentType, property, system, aggr, parent, pluginid
    }
    
    init() {}

    init(id: String?, action: String?, account: String?, documentType: String?, property: Property?, system: System?, aggr: Aggr?, parent: Parent?, pluginid: String?) {
        self.id = id
        self.action = action
        self.account = account
        self.documentType = documentType
        self.property = property ?? Property()
        self.system = system ?? System()
        self.aggr = aggr ?? Aggr()
        self.parent = parent ?? Parent()
        self.pluginid = pluginid
    }
}

// MARK: - Aggr

class Aggr: Codable {

    init() {}
}

// MARK: - Parent

class Parent: Codable {
    var user, session: String?
    
    init() {}

    init(user: String?, session: String?) {
        self.user = user
        self.session = session
    }
}

// MARK: - Property

class Property: Codable {
    var navigatorLanguage, navigatorUseragent: String?
    var windowScreenWidth, windowScreenHeight: Int?
    var documentCharacterset, navigatorJavaenabled: String?
    var windowViewportWidth, windowViewportHeight, windowScreenColordepth: Int?
    var sessionDocID, navigatorPlatform, navigatorCookieenabled: String?
    var windowScreenAvailwidth, windowScreenAvailheight: Int?
    var navigatorLanguages: [String]?
    var timezoneOffsetMinutes: Int?
    var adfCookieID, jtsVersion, jtsDebug: String?
    var jtspushedcommands: [String]?
    var gaFeCid, gaFeGid: String?
    var documentRef: String?
    var documentTitle: String?
    var windowLocationHref: String?
    var searchParamUtmTerm, searchParamUtmMedium, searchParamUtmSource, searchParamUtmContent: String?
    var gaOptimizeExperimentID, searchParamUtmCampaign: String?
    var dateNow: Int?
    var readCookies: Cookies?
    var rtbLid, userDocID: String?
    var cookies: Cookies?
    var eventDocID: String?
    var urlParameters: Aggr?
    var documentLocationHref: String?
    var searchParamEmid, hrefPathname: String?
    var hubsBrowserFingerprint: Int?
    var obBust, orderBrutto, orderID, orderDiscount: String?
    var orderVouchers, documentRefDiff, jConsentID, adfAdvertiserDomain: String?
    var fbClickID, fbBrowserID: String?
    var jtsSysTrigger: JtsSysTrigger?
    var productBrand, productCategory: [JSONAny]?
    var hashedPlugins, randomNumber1E6: Int?

    enum CodingKeys: String, CodingKey {
        case navigatorLanguage = "navigator_language"
        case navigatorUseragent = "navigator_useragent"
        case windowScreenWidth = "window_screen_width"
        case windowScreenHeight = "window_screen_height"
        case documentCharacterset = "document_characterset"
        case navigatorJavaenabled = "navigator_javaenabled"
        case windowViewportWidth = "window_viewport_width"
        case windowViewportHeight = "window_viewport_height"
        case windowScreenColordepth = "window_screen_colordepth"
        case sessionDocID = "session_doc_id"
        case navigatorPlatform = "navigator_platform"
        case navigatorCookieenabled = "navigator_cookieenabled"
        case windowScreenAvailwidth = "window_screen_availwidth"
        case windowScreenAvailheight = "window_screen_availheight"
        case navigatorLanguages = "navigator_languages"
        case timezoneOffsetMinutes = "timezone_offset_minutes"
        case adfCookieID = "adf_cookie_id"
        case jtsVersion = "jts_version"
        case jtsDebug = "jts_debug"
        case jtspushedcommands
        case gaFeCid = "ga_fe_cid"
        case gaFeGid = "ga_fe_gid"
        case documentRef = "document_ref"
        case documentTitle = "document_title"
        case windowLocationHref = "window_location_href"
        case searchParamUtmTerm = "search_param_utm_term"
        case searchParamUtmMedium = "search_param_utm_medium"
        case searchParamUtmSource = "search_param_utm_source"
        case searchParamUtmContent = "search_param_utm_content"
        case gaOptimizeExperimentID = "ga_optimize_experiment_id"
        case searchParamUtmCampaign = "search_param_utm_campaign"
        case dateNow = "date_now"
        case readCookies = "read_cookies"
        case rtbLid = "rtb_lid"
        case userDocID = "user_doc_id"
        case cookies
        case eventDocID = "event_doc_id"
        case urlParameters = "url_parameters"
        case documentLocationHref = "document_location_href"
        case searchParamEmid = "search_param_emid"
        case hrefPathname = "href_pathname"
        case hubsBrowserFingerprint = "hubs_browser_fingerprint"
        case obBust = "ob_bust"
        case orderBrutto = "order_brutto"
        case orderID = "order_id"
        case orderDiscount = "order_discount"
        case orderVouchers = "order_vouchers"
        case documentRefDiff = "document_ref_diff"
        case jConsentID = "j_consent_id"
        case adfAdvertiserDomain = "adf_advertiser_domain"
        case fbClickID = "fb_click_id"
        case fbBrowserID = "fb_browser_id"
        case jtsSysTrigger = "_jts_sys_trigger"
        case productBrand = "product_brand"
        case productCategory = "product_category"
        case hashedPlugins = "hashed-plugins"
        case randomNumber1E6 = "random_number_1e6"
    }
    
    init() {}

    init(navigatorLanguage: String?, navigatorUseragent: String?, windowScreenWidth: Int?, windowScreenHeight: Int?, documentCharacterset: String?, navigatorJavaenabled: String?, windowViewportWidth: Int?, windowViewportHeight: Int?, windowScreenColordepth: Int?, sessionDocID: String?, navigatorPlatform: String?, navigatorCookieenabled: String?, windowScreenAvailwidth: Int?, windowScreenAvailheight: Int?, navigatorLanguages: [String]?, timezoneOffsetMinutes: Int?, adfCookieID: String?, jtsVersion: String?, jtsDebug: String?, jtspushedcommands: [String]?, gaFeCid: String?, gaFeGid: String?, documentRef: String?, documentTitle: String?, windowLocationHref: String?, searchParamUtmTerm: String?, searchParamUtmMedium: String?, searchParamUtmSource: String?, searchParamUtmContent: String?, gaOptimizeExperimentID: String?, searchParamUtmCampaign: String?, dateNow: Int?, readCookies: Cookies?, rtbLid: String?, userDocID: String?, cookies: Cookies?, eventDocID: String?, urlParameters: Aggr?, documentLocationHref: String?, searchParamEmid: String?, hrefPathname: String?, hubsBrowserFingerprint: Int?, obBust: String?, orderBrutto: String?, orderID: String?, orderDiscount: String?, orderVouchers: String?, documentRefDiff: String?, jConsentID: String?, adfAdvertiserDomain: String?, fbClickID: String?, fbBrowserID: String?, jtsSysTrigger: JtsSysTrigger?, productBrand: [JSONAny]?, productCategory: [JSONAny]?, hashedPlugins: Int?, randomNumber1E6: Int?) {
        self.navigatorLanguage = navigatorLanguage
        self.navigatorUseragent = navigatorUseragent
        self.windowScreenWidth = windowScreenWidth
        self.windowScreenHeight = windowScreenHeight
        self.documentCharacterset = documentCharacterset
        self.navigatorJavaenabled = navigatorJavaenabled
        self.windowViewportWidth = windowViewportWidth
        self.windowViewportHeight = windowViewportHeight
        self.windowScreenColordepth = windowScreenColordepth
        self.sessionDocID = sessionDocID
        self.navigatorPlatform = navigatorPlatform
        self.navigatorCookieenabled = navigatorCookieenabled
        self.windowScreenAvailwidth = windowScreenAvailwidth
        self.windowScreenAvailheight = windowScreenAvailheight
        self.navigatorLanguages = navigatorLanguages
        self.timezoneOffsetMinutes = timezoneOffsetMinutes
        self.adfCookieID = adfCookieID
        self.jtsVersion = jtsVersion
        self.jtsDebug = jtsDebug
        self.jtspushedcommands = jtspushedcommands
        self.gaFeCid = gaFeCid
        self.gaFeGid = gaFeGid
        self.documentRef = documentRef
        self.documentTitle = documentTitle
        self.windowLocationHref = windowLocationHref
        self.searchParamUtmTerm = searchParamUtmTerm
        self.searchParamUtmMedium = searchParamUtmMedium
        self.searchParamUtmSource = searchParamUtmSource
        self.searchParamUtmContent = searchParamUtmContent
        self.gaOptimizeExperimentID = gaOptimizeExperimentID
        self.searchParamUtmCampaign = searchParamUtmCampaign
        self.dateNow = dateNow
        self.readCookies = readCookies
        self.rtbLid = rtbLid
        self.userDocID = userDocID
        self.cookies = cookies
        self.eventDocID = eventDocID
        self.urlParameters = urlParameters
        self.documentLocationHref = documentLocationHref
        self.searchParamEmid = searchParamEmid
        self.hrefPathname = hrefPathname
        self.hubsBrowserFingerprint = hubsBrowserFingerprint
        self.obBust = obBust
        self.orderBrutto = orderBrutto
        self.orderID = orderID
        self.orderDiscount = orderDiscount
        self.orderVouchers = orderVouchers
        self.documentRefDiff = documentRefDiff
        self.jConsentID = jConsentID
        self.adfAdvertiserDomain = adfAdvertiserDomain
        self.fbClickID = fbClickID
        self.fbBrowserID = fbBrowserID
        self.jtsSysTrigger = jtsSysTrigger
        self.productBrand = productBrand
        self.productCategory = productCategory
        self.hashedPlugins = hashedPlugins
        self.randomNumber1E6 = randomNumber1E6
    }
}

// MARK: - Cookies

class Cookies: Codable {
    var jtsLog, fbp, jtsRw, jtsFbp: String?
    var jtsGaFeGid, jtsGaFeCid, fbc, jtsFbc: String?
    var ga, gclAu, gclAw, jAdfID: String?
    var jctrSid, pkSes0066, gatGtagUA220398793_2, jtsGa: String?
    var jtsGaGid, ctoBundle, ga3Z29BF112E: String?

    enum CodingKeys: String, CodingKey {
        case jtsLog = "jts_log"
        case fbp = "_fbp"
        case jtsRw = "jts-rw"
        case jtsFbp = "jts-fbp"
        case jtsGaFeGid = "jts-ga-fe-gid"
        case jtsGaFeCid = "jts-ga-fe-cid"
        case fbc = "_fbc"
        case jtsFbc = "jts-fbc"
        case ga = "_ga"
        case gclAu = "_gcl_au"
        case gclAw = "_gcl_aw"
        case jAdfID = "j_adf_id"
        case jctrSid = "jctr_sid"
        case pkSes0066 = "_pk_ses..0066"
        case gatGtagUA220398793_2 = "_gat_gtag_UA_220398793_2"
        case jtsGa = "jts_ga"
        case jtsGaGid = "jts_ga_gid"
        case ctoBundle = "cto_bundle"
        case ga3Z29BF112E = "_ga_3Z29BF112E"
    }
    
    init() {}

    init(jtsLog: String?, fbp: String?, jtsRw: String?, jtsFbp: String?, jtsGaFeGid: String?, jtsGaFeCid: String?, fbc: String?, jtsFbc: String?, ga: String?, gclAu: String?, gclAw: String?, jAdfID: String?, jctrSid: String?, pkSes0066: String?, gatGtagUA220398793_2: String?, jtsGa: String?, jtsGaGid: String?, ctoBundle: String?, ga3Z29BF112E: String?) {
        self.jtsLog = jtsLog
        self.fbp = fbp
        self.jtsRw = jtsRw
        self.jtsFbp = jtsFbp
        self.jtsGaFeGid = jtsGaFeGid
        self.jtsGaFeCid = jtsGaFeCid
        self.fbc = fbc
        self.jtsFbc = jtsFbc
        self.ga = ga
        self.gclAu = gclAu
        self.gclAw = gclAw
        self.jAdfID = jAdfID
        self.jctrSid = jctrSid
        self.pkSes0066 = pkSes0066
        self.gatGtagUA220398793_2 = gatGtagUA220398793_2
        self.jtsGa = jtsGa
        self.jtsGaGid = jtsGaGid
        self.ctoBundle = ctoBundle
        self.ga3Z29BF112E = ga3Z29BF112E
    }
}

// MARK: - JtsSysTrigger

class JtsSysTrigger: Codable {
    var pageviewWithoutExclude: PageviewWithoutExclude?

    enum CodingKeys: String, CodingKey {
        case pageviewWithoutExclude = "pageview_without_exclude"
    }
    
    init() {}

    init(pageviewWithoutExclude: PageviewWithoutExclude?) {
        self.pageviewWithoutExclude = pageviewWithoutExclude
    }
}

// MARK: - PageviewWithoutExclude

class PageviewWithoutExclude: Codable {
    var fbEventID: String?

    enum CodingKeys: String, CodingKey {
        case fbEventID = "fb_event_id"
    }
    
    init() {}

    init(fbEventID: String?) {
        self.fbEventID = fbEventID
    }
}

// MARK: - System

class System: Codable {
    var navigatorUserAgent: String?
    var href: String?
    var consent: [String: Bool]?

    enum CodingKeys: String, CodingKey {
        case navigatorUserAgent = "navigator-userAgent"
        case href, consent
    }
    
    init() {}

    init(navigatorUserAgent: String?, href: String?, consent: [String: Bool]?) {
        self.navigatorUserAgent = navigatorUserAgent
        self.href = href
        self.consent = consent
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (_: JSONNull, _: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }
    
    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue _: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: value)
        }
    }
}
