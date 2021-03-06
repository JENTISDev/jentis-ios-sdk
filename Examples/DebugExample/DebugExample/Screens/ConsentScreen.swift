import Jentis
import SwiftUI

struct ConsentScreen: View {
    @State private var trackingSelections: [String: Bool] = [:]
    @State private var consentID: String?
    @State private var lastUpdate: String?
    @State private var displayAlert: Bool = false

    var body: some View {
        return VStack {
            Text("Consent ID: \(consentID ?? "")")
            Text("Last consent update: \(lastUpdate ?? "")")
            List(trackingSelections.sorted(by: { a, b in a.key > b.key }), id: \.key) { key, _ in
                Toggle(key, isOn: self.binding(for: key))
            }
            Button("Submit") {
                Task {
                    let result = await TrackService.shared.setConsents(consents: trackingSelections)
                    switch result {
                    case .success:
                        consentID = TrackService.shared.getConsentId()
                    case .failure:
                        displayAlert = true
                    }
                }
            }
        }
        .alert("An error occured", isPresented: $displayAlert) {
            Button("OK", role: .cancel) {}
        }
        .navigationTitle("Consent Screen")
        .onAppear {
            consentID = TrackService.shared.getConsentId()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d.MM.YY HH:mm:ss"
            if let lastUpdateDate = TrackService.shared.getLastConsentUpdate() {
                lastUpdate = dateFormatter.string(from: lastUpdateDate)
            }

            if let trackingOptions = TrackService.shared.getCurrentConsents() {
                trackingSelections = trackingOptions
            } else {
                var dict: [String: Bool] = [:]
                for trackingOption in TrackingOptions.allCases {
                    dict[trackingOption.rawValue] = false
                }
                trackingSelections = dict
            }
        }
    }

    private func binding(for key: String) -> Binding<Bool> {
        return .init(
            get: { self.trackingSelections[key, default: false] },
            set: { self.trackingSelections[key] = $0 }
        )
    }
}

struct SecondScreen_Previews: PreviewProvider {
    static var previews: some View {
        ConsentScreen()
    }
}
