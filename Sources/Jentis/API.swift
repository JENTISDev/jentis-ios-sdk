import Foundation

class API {
    static let shared = API()

    private var baseUrl: URL?

    private init() {}

    func setup(baseUrl: String) {
        self.baseUrl = URL(string: baseUrl)
    }

    func trackDefault(_ trackingData: TrackingData) {
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(trackingData)

            submitTracking(jsonData)
        } catch {
            print(error)
        }
    }
    
    func trackCustom(_ customData: Data) {
        submitTracking(customData)
    }
    
    private func submitTracking(_ data: Data) {
        guard let baseUrl = baseUrl else {
            return
        }
        
        var request = URLRequest(url: baseUrl)
        request.httpMethod = "POST"
        request.httpBody = data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                    print(httpResponse.statusCode)
                }
        }.resume()
    }
}
