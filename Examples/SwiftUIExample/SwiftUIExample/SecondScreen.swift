//
//  SecondScreen.swift
//  Jentis
//
//  Created by Andreas Mühleder on 14.06.22.
//

import SwiftUI
import Jentis

struct SecondScreen: View {
    var body: some View {
        Text("👋🏻")
            .onAppear {
                TrackService.shared.trackDefault(currentView: "SecondScreen")
            }
            .navigationTitle("Second Screen")
    }
}

struct SecondScreen_Previews: PreviewProvider {
    static var previews: some View {
        SecondScreen()
    }
}
