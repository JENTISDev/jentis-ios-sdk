import Foundation

extension String {
    static func randomId(digits: Int = Config.Tracking.idLength) -> String {
        var id = String()
        for _ in 1 ... digits {
            id += "\(Int.random(in: 1 ... 9))"
        }
        return id
    }
}
