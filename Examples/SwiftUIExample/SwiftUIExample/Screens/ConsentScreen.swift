import Jentis
import SwiftUI

struct ConsentScreen: View {
    @State private var trackingSelections: [String: Bool] = [:]

    var body: some View {
        return VStack {
            List(trackingSelections.sorted(by: { a, b in a.key > b.key }), id: \.key) { key, value in
                Toggle(key, isOn: self.binding(for: key))
            }
            Button("Submit") {
                TrackService.shared.setConsents(consents: trackingSelections)
            }
        }
        .navigationTitle("Second Screen")
        .onAppear {
            if let trackingOptions = TrackService.shared.getCurrentConsents() {
                trackingSelections = trackingOptions
            } else {
                var dict: [String: Bool] = [:]
                for trackingOption in TrackingOptions.allCases {
                    dict[trackingOption.rawValue] = true
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
