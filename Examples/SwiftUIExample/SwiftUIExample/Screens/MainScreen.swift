import Jentis
import SwiftUI

struct MainScreen: View {
    init() {
        let config = TrackConfig(trackDomain: "https://kndmjh.allaboutapps.jtm-demo.com/", trackID: "allaboutapps", environment: .live)

        TrackService.shared.initTracking(config: config)
        TrackService.shared.debugTracking(true, debugId: "62a9e9c727255", version: "2")
    }

    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: ConsentScreen()) {
                    Text("Consent Screen")
                }
                NavigationLink(destination: TrackingScreen()) {
                    Text("Tracking Screen")
                }
            }
            .navigationTitle("First Screen")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
