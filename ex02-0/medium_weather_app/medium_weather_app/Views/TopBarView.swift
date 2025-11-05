//
//  LocationBarView.swift
//  weather_app
//
//  Created by jules bernard on 30.10.25.
//

import SwiftUI
import CoreLocation

struct SearchBar: View {
    @ObservedObject var cityBarViewModel: LocationViewModel
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.white)
                .padding(.leading, 16)
                .padding(.trailing, 0)
            
            TextField("City", text: $cityBarViewModel.searchText)
                .border(.clear)
                .padding(12)
                .foregroundColor(.white)
                .onSubmit {
                    cityBarViewModel.midText = cityBarViewModel.searchText
                }
        }
    }
}

struct GpsButton: View {
    @ObservedObject var locationViewModel: LocationViewModel
    var locationService: LocationService
    @State private var didError = false
    
    init(locationViewModel: LocationViewModel) {
        self.locationViewModel = locationViewModel
        self.locationService = LocationService(locationViewModel: locationViewModel)
    }
    
    var body: some View {
        Button(action: {
            locationService.locationManagerDidChangeAuthorization()
            if [.restricted, .denied].contains(locationService.manager.authorizationStatus) {
                didError = true
            }
            locationService.manager.requestLocation()
        }) {
            Image(systemName: "location.fill")
                .imageScale(.large)
                .foregroundColor(.white)
                .padding(9)
                .opacity(0.8)
        }
        .alert(
            "Location not authorized",
            isPresented: $didError,
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


struct TopBarView: View {
    @ObservedObject var cityBarViewModel: LocationViewModel
    var body: some View {
        
        if #available(iOS 26.0, *) {
            GlassEffectContainer(spacing: 20.0) {
                HStack {
                    SearchBar(cityBarViewModel: cityBarViewModel)
                        .glassEffect(.clear)
                    
                    GpsButton(locationViewModel: cityBarViewModel)
                        .glassEffect(.clear)
                }
                .padding()
            }
        } else {
            HStack {
                SearchBar(cityBarViewModel: cityBarViewModel)
                    .background(.white.opacity(0.4))
                    .border(.white)
                    .cornerRadius(30)
                
                GpsButton(locationViewModel: cityBarViewModel)
            }
            .padding()
        }

    }
}

#Preview {
    MainView()
}
