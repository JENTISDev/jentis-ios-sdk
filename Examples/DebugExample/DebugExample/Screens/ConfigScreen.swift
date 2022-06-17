import Jentis
import SwiftUI

struct ConfigScreen: View {
    @State private var trackDomain: String = "https://kndmjh.allaboutapps.jtm-demo.com/"
    @State private var trackId: String = "allaboutapps"
    @State private var environment: TrackConfig.Environment = .live

    var body: some View {
        VStack {
            List {
                TextField("track domain", text: $trackDomain)
                    .textInputAutocapitalization(.none)
                TextField("track id", text: $trackId)
                    .textInputAutocapitalization(.none)
                Picker("environment", selection: $environment) {
                    ForEach(TrackConfig.Environment.allCases, id: \.self) { value in
                        Text(value.rawValue)
                            .tag(value)
                    }
                }
            }
            Button("Submit") {
                let config = TrackConfig(trackDomain: trackDomain, trackID: trackId, environment: environment)
                TrackService.shared.initTracking(config: config)
            }
        }
        .navigationTitle("Config")
    }
}

struct ConfigScreen_Previews: PreviewProvider {
    static var previews: some View {
        ConfigScreen()
    }
}
