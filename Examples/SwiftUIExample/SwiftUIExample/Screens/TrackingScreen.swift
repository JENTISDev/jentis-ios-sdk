import SwiftUI
import Jentis

struct TrackingScreen: View {
    var body: some View {
        Text("👋🏻")
            .onAppear {
                TrackService.shared.push(data: ["track":"pageview", "pagetitle":"Tracking Screen", "virtualPagePath":"MainScreen/TrackingScreen"])
                TrackService.shared.push(data: ["track":"submit"])
            }
            .navigationTitle("Tracking Screen")
    }
}

struct ThirdScreen_Previews: PreviewProvider {
    static var previews: some View {
        TrackingScreen()
    }
}
