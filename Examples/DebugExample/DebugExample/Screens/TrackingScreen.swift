import Jentis
import SwiftUI

struct TrackingScreen: View {
    @State private var track: String = "pageview"
    @State private var pagetitle: String = "Tracking Screen"
    @State private var virtualPagePath: String = "MainScreen/TrackingScreen"

    var body: some View {
        VStack {
            List {
                TextField("track", text: $track)
                    .textInputAutocapitalization(.none)
                TextField("pagetitle", text: $pagetitle)
                    .textInputAutocapitalization(.none)
                TextField("virtualPagePath", text: $virtualPagePath)
                    .textInputAutocapitalization(.none)
            }
            Button("Submit") {
                var data = ["track": track, "pagetitle": pagetitle, "virtualPagePath": virtualPagePath]
                
                for (key, value) in data where value == "" {
                    data.removeValue(forKey: key)
                }
                
                TrackService.shared.push(data: data)
            }
        }
        .navigationTitle("Tracking Screen")
    }
}

struct ThirdScreen_Previews: PreviewProvider {
    static var previews: some View {
        TrackingScreen()
    }
}
