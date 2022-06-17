import Foundation

// MARK: - TrackingData

class JentisData: Codable {
    var client: Client?
    var cmd: Cmd = .init()
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
    var clientTimestamp: Int64?
    var domain: String?

    init() {}

    init(clientTimestamp: Int64?, domain: String?) {
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
    var property: Property = .init()
    var system: System?
    var aggr: Aggr = .init()
    var parent: Parent = .init()
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
        self.system = system
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
    var appDeviceBrand, appDeviceModel, appDeviceOS, appDeviceOSVersion: String?
    var appDeviceLanguage: String?
    var appDeviceWidth, appDeviceHeight: Int?
    var appApplicationName, appApplicationVersion: String?
    var appApplicationBuildNumber: String?
    var jtsDebug, jtsVersion: String?
    var jtspushedcommands: [String]?
    var documentRef: String?
    var documentTitle: String?
    var windowLocationHref: String?
    var dateNow: Int?
    var userDocID, eventDocID: String?
    var documentLocationHref: String?
    var track, consentid: String?
    var lastupdate: Int64?
    var vendors: [String: Bool]?
    var send, userconsent: Bool?
    var vendorsChanged: [String: Bool]?

    enum CodingKeys: String, CodingKey {
        case appDeviceBrand = "app_device_brand"
        case appDeviceModel = "app_device_model"
        case appDeviceOS = "app_device_os"
        case appDeviceOSVersion = "app_device_os_version"
        case appDeviceLanguage = "app_device_language"
        case appDeviceWidth = "app_device_width"
        case appDeviceHeight = "app_device_height"
        case appApplicationName = "app_application_name"
        case appApplicationVersion = "app_application_version"
        case appApplicationBuildNumber = "app_application_build_number"
        case jtsDebug = "jts_debug"
        case jtsVersion = "jts_version"
        case jtspushedcommands
        case documentRef = "document_ref"
        case documentTitle = "document_title"
        case windowLocationHref = "window_location_href"
        case dateNow = "date_now"
        case userDocID = "user_doc_id"
        case eventDocID = "event_doc_id"
        case documentLocationHref = "document_location_href"
        case track, consentid, lastupdate, vendors, send, userconsent, vendorsChanged
    }

    init() {}

    init(appDeviceBrand: String?, appDeviceModel: String?, appDeviceOS: String?, appDeviceOSVersion: String?, appDeviceLanguage: String?, appDeviceWidth: Int?, appDeviceHeight: Int?, appApplicationName: String?, appApplicationVersion: String?, appApplicationBuildNumber: String?, jtsDebug: String?, jtsVersion: String?, jtspushedcommands: [String]?, documentRef: String?, documentTitle: String?, windowLocationHref: String?, dateNow: Int?, userDocID: String?, eventDocID: String?, documentLocationHref: String?, track: String?, consentid: String?, lastupdate: Int64?, vendors: [String: Bool]?, send: Bool?, userconsent: Bool?, vendorsChanged: [String: Bool]?) {
        self.appDeviceBrand = appDeviceBrand
        self.appDeviceModel = appDeviceModel
        self.appDeviceOS = appDeviceOS
        self.appDeviceOSVersion = appDeviceOSVersion
        self.appDeviceLanguage = appDeviceLanguage
        self.appDeviceWidth = appDeviceWidth
        self.appDeviceHeight = appDeviceHeight
        self.appApplicationName = appApplicationName
        self.appApplicationVersion = appApplicationVersion
        self.appApplicationBuildNumber = appApplicationBuildNumber
        self.jtsDebug = jtsDebug
        self.jtsVersion = jtsVersion
        self.jtspushedcommands = jtspushedcommands
        self.documentRef = documentRef
        self.documentTitle = documentTitle
        self.windowLocationHref = windowLocationHref
        self.dateNow = dateNow
        self.userDocID = userDocID
        self.eventDocID = eventDocID
        self.documentLocationHref = documentLocationHref
        self.track = track
        self.consentid = consentid
        self.lastupdate = lastupdate
        self.vendors = vendors
        self.send = send
        self.userconsent = userconsent
        self.vendorsChanged = vendorsChanged
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
    var environment: String?
    var navigatorUserAgent: String?
    var href: String?
    var consent: [String: Bool]?

    enum CodingKeys: String, CodingKey {
        case navigatorUserAgent = "navigator-userAgent"
        case href, consent, environment
    }

    init() {}

    init(navigatorUserAgent: String?, href: String?, consent: [String: Bool]?, environment: String?) {
        self.navigatorUserAgent = navigatorUserAgent
        self.href = href
        self.consent = consent
        self.environment = environment
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
