import Jentis
import SwiftUI

struct TrackingScreen: View {
    var body: some View {
        Text("👋🏻")
            .onAppear {
                let jsonStr = """
                {"property1":"value1", "property2":"value2"}
                """.jentisToJSON() as Any
                
                TrackService.shared.push(data: ["track": "pageview", "pagetitle": "Tracking Screen", "virtualPagePath": "MainScreen/TrackingScreen", "testArray": ["property1": ["value1", "value2"], "property2":"value2"], "testJSON": jsonStr])
                TrackService.shared.push(data: ["track": "submit"])
            }
            .navigationTitle("Tracking Screen")
    }
}


struct ThirdScreen_Previews: PreviewProvider {
    static var previews: some View {
        TrackingScreen()
    }
}
