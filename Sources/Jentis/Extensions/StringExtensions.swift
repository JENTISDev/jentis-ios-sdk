import Foundation

extension String {
    // Generates a random ID
    static func randomId(digits: Int = Config.Tracking.idLength) -> String {
        var id = String()
        for _ in 1 ... digits {
            id += "\(Int.random(in: 1 ... 9))"
        }
        return id
    }

    // Returns the device model
    static var deviceModel: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        return machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
    }

    // Deletes the prefix from a string
    func deletingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else { return self }
        return String(dropFirst(prefix.count))
    }
}
