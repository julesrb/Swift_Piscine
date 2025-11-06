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
    @Binding var showOverlay: Bool
    @FocusState private var isFocused: Bool
    
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
                .focused($isFocused)
                .onSubmit {
                    cityBarViewModel.searchText = ""
                }
        }
        .contentShape(Rectangle()) // makes the whole HStack tappable
        .onTapGesture {
            showOverlay.toggle()
        }
        .onChange(of: isFocused) {
            showOverlay = isFocused
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

struct TopBarView: View {
    @ObservedObject var cityBarViewModel: LocationViewModel
    @Binding var showOverlay: Bool
    
    let mockCities = ["Berlin", "Paris", "Tokyo", "New York"]
    var body: some View {
        VStack {
            if #available(iOS 26.0, *) {
                GlassEffectContainer(spacing: 20.0) {
                    HStack {
                        SearchBar(cityBarViewModel: cityBarViewModel, showOverlay: $showOverlay)
                            .glassEffect(.clear)
                        
                        GpsButton(locationViewModel: cityBarViewModel)
                            .glassEffect(.clear)
                    }
                    .padding()
                }
            } else {
                HStack {
                    SearchBar(cityBarViewModel: cityBarViewModel, showOverlay: $showOverlay)
                        .background(.white.opacity(0.4))
                        .border(.white)
                        .cornerRadius(30)
                    
                    GpsButton(locationViewModel: cityBarViewModel)
                }
                .padding()
            }
            if showOverlay {
                ScrollView {
                    VStack {
                        ForEach(cityBarViewModel.cityList) { city in
                            Text("\(city.name) \(city.admin1), \(city.country ?? "")")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundStyle(.white)
                                .padding(.bottom, 12)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    showOverlay = false
                                    Task {
                                        do {
                                            let data = try await WeatherAPI.fetchWeather(lat: city.latitude, longi: city.longitude)
                                            print(data)
                                        } catch {
                                            print("error with API call")
                                        }
                                    }
                                }
                        }
                    }
                    .offset(x: 35, y: 0)
                }
            }
        }
    }
}

#Preview {
    MainView()
}

