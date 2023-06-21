import Jentis
import SwiftUI

struct ProductScreen: View {
    var body: some View {
        Text("👋🏻")
            .onAppear {
                let jsonStr = """
                {"property1":"value1", "property2":"value2"}
                """.jentisToJSON() as Any

                TrackService.shared.push(data: ["track": "pageview", "pagetitle": "Tracking Screen", "virtualPagePath": "MainScreen/TrackingScreen", "testArray": ["property1": ["value1", "value2"], "property2": "value2"], "testJSON": jsonStr])
                TrackService.shared.push(data: ["track": "product",
                                                "type": "order",
                                                "id": 12_345_567,
                                                "name": "Baby Oil"])
                TrackService.shared.push(data: ["track": "product",
                                                "type": "order",
                                                "id": 11_111_111,
                                                "name": "Nivea",
                                                "missing": 110.0])
                TrackService.shared.push(data: ["track": "product",
                                                "type": "productview",
                                                "id": 9_999_999,
                                                "name": "APP DEVELOPMENT",
                                                "color": "blue"])
                TrackService.shared.push(data: ["track": "order"])
                TrackService.shared.push(data: ["track": "submit"])
            }
            .navigationTitle("Tracking Screen")
    }
}
