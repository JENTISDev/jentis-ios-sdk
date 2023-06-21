import Jentis
import SwiftUI

struct MainScreen: View {
    init() {
        let config = TrackConfig(trackDomain: "https://kndmjj.allaboutapps.jtm-demo.com/", trackID: "allaboutapps", environment: .stage)

        TrackService.shared.initTracking(config: config)
        TrackService.shared.debugTracking(true, debugId: "fb97255b-4bc4-459f-acdb-e7ac792924d4", version: "2")
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
                NavigationLink(destination: ProductScreen()) {
                    Text("Product Screen")
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
