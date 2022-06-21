import Jentis
import SwiftUI

struct MainScreen: View {
    init() {
        let config = TrackConfig(trackDomain: "https://kndmjh.allaboutapps.jtm-demo.com/", trackID: "allaboutapps", environment: .live)

        TrackService.shared.initTracking(config: config)
        TrackService.shared.debugTracking(true, debugId: "62b190593ac89", version: "2")
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
            .navigationTitle("Main Screen")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
