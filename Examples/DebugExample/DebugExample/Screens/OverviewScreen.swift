import SwiftUI

struct OverviewScreen: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: ConfigScreen()) {
                    Text("Config Screen")
                }
                NavigationLink(destination: DebugScreen()) {
                    Text("Debug Screen")
                }
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
        OverviewScreen()
    }
}
