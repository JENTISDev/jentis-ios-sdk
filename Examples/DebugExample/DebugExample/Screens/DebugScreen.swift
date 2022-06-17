import Jentis
import SwiftUI

struct DebugScreen: View {
    @State private var enabled: Bool = true
    @State private var debugId: String = "62a9e9c727255"
    @State private var debugVersion: String = "2"

    var body: some View {
        VStack {
            List {
                Toggle("Enabled", isOn: $enabled)
                TextField("Debug ID", text: $debugId)
                    .textInputAutocapitalization(.none)
                TextField("Debug Version", text: $debugVersion)
                    .textInputAutocapitalization(.none)
            }
            Button("Submit") {
                TrackService.shared.debugTracking(enabled, debugId: debugId, version: debugVersion)
            }
        }
        .navigationTitle("Debug Screen")
    }
}

struct DebugScreen_Previews: PreviewProvider {
    static var previews: some View {
        DebugScreen()
    }
}
