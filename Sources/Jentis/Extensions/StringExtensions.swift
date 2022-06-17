import Foundation

extension String {
    static func randomId(digits: Int = Config.Tracking.idLength) -> String {
        var id = String()
        for _ in 1 ... digits {
            id += "\(Int.random(in: 1 ... 9))"
        }
        return id
    }

    static var deviceModel: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        return machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
    }

    func deletingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else { return self }
        return String(dropFirst(prefix.count))
    }
}
