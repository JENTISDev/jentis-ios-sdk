import Jentis
import SwiftUI

struct ProductScreen: View {
    var body: some View {
        Text("👋🏻")
            .onAppear {
                TrackService.shared.push(data: ["track": "product",
                                                "type": "order",
                                                "id": 12_345_567,
                                                "name": "Baby Oil"])
                TrackService.shared.push(data: ["track" : "product",
                                                "type"  : "order",
                                                "id"    : 11111111,
                                                "name"  : "Nivea",
                                                "missing" : 110.0])
                TrackService.shared.push(data: ["track" : "product",
                                                "type"  : "productview",
                                                "id"    : 9999999,
                                                "name"  : "APP DEVELOPMENT",
                                                "color" : "blue"])
                TrackService.shared.push(data: ["track": "submit"])
            }
            .navigationTitle("Tracking Screen")
    }
}
