import Jentis
import SwiftUI

struct FirstScreen: View {
    init() {
        let config = TrackConfig(trackDomain: "https://kndmjh.allaboutapps.jtm-demo.com/", trackID: "allaboutapps", environment: .live)

        TrackService.shared.initTracking(config: config)
        TrackService.shared.debugTracking(true, debugId: "62a85ae3b4602", version: "2")
    }

    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: SecondScreen()) {
                    Text("Second Screen")
                }
                NavigationLink(destination: ThirdScreen()) {
                    Text("Third Screen")
                }
            }
            .onAppear {
                TrackService.shared.trackDefault(currentView: "FirstScreen")
            }
            .navigationTitle("First Screen")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FirstScreen()
    }
}
