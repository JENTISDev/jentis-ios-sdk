import Foundation

class API {
    static let shared = API()

    private var baseUrl: URL?

    private init() {}

    func setup(baseUrl: String) {
        self.baseUrl = URL(string: baseUrl)
    }

    func setConsentSettings(_ trackingData: JentisData, completion : @escaping (Result<Void, JentisError>) -> Void) {
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(trackingData)

            submitTracking(jsonData) {result in
                switch result {
                case .success(_):
                    completion(.success(()))
                    break
                case .failure(_):
                    completion(.failure(.setConsentError))
                    break
                }
            }
        } catch {
            completion(.failure(.setConsentError))
            print("[JENTIS] Error: \(error)")
        }
    }

    func submitTracking(_ data: Data, completion : @escaping (Result<Void, JentisError>) -> Void) {
        guard let baseUrl = baseUrl else {
            return
        }

        var request = URLRequest(url: baseUrl)
        request.httpMethod = "POST"
        request.httpBody = data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { _, response, _ in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(.success(()))
            } else {
                completion(.failure(.requestError))
            }
        }.resume()
    }
}
