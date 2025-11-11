//
//  GpsButton.swift
//  advanced_weather_app
//
//  Created by jules bernard on 11.11.25.
//

import SwiftUI
import CoreLocation


struct GpsButton: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var locationVM: LocationVM
    @State private var didError = false
    
    init(locationVM: LocationVM) {
        self.locationVM = locationVM
    }
    
    var body: some View {
        Button(action: {
            locationVM.locationService.checkAuthorization()
            if [.restricted, .denied].contains(locationVM.locationService.manager.authorizationStatus) {
                didError = true
            }
        }) {
            Image(systemName: "location.fill")
                .imageScale(.large)
                .foregroundColor(.white)
                .padding(9)
                .opacity(0.8)
        }
        .alert(
            "Location not authorized",
            isPresented: $didError
        ) {
            Button(role: .destructive) {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            } label: {
                Text("Open Settings")
            }
        } message: {
            Text("To use located weather, we advice you to authorize location in your settings")
        }
    }
}
