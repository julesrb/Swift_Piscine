//
//  LocationBarView.swift
//  weather_app
//
//  Created by jules bernard on 30.10.25.
//

import SwiftUI
import CoreLocation

struct SearchBar: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var locationVM: LocationVM
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.white)
                .padding(.leading, 16)
                .padding(.trailing, 0)
            
            TextField("City", text: $locationVM.searchText)
                .border(.clear)
                .padding(12)
                .foregroundColor(.white)
                .onSubmit {
                    locationVM.searchText = ""
                    guard let firstCity = locationVM.cityList.first else {
                        print("No city selected")
                        appState.appError = AppError.notFound
                        appState.error = true
                        return
                    }
                    locationVM.latiLongi = [firstCity.latitude, firstCity.longitude]
                    locationVM.name = firstCity.name
                    locationVM.admin1 = firstCity.admin1
                    locationVM.country = firstCity.country
                }
        }
        .contentShape(Rectangle()) // makes the whole HStack tappable
        .onTapGesture {
            appState.showOverlay.toggle()
        }
    }
}

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

struct CityScrollList: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var locationVM: LocationVM
    @FocusState.Binding var isFocused: Bool
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(locationVM.cityList) { city in
                    Text("\(city.name) \(city.admin1), \(city.country)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(.white)
                        .padding(.bottom, 12)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            locationVM.searchText = ""
                            appState.showOverlay = false
                            locationVM.latiLongi = [city.latitude, city.longitude]
                            locationVM.name = city.name
                            locationVM.admin1 = city.admin1
                            locationVM.country = city.country
                            isFocused = false
                        }
                }
            }
            .offset(x: 35, y: 0)
        }
    }
}

struct TopBarView: View {
    @ObservedObject var locationVM: LocationVM
    @FocusState private var isFocused: Bool
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack {
            if #available(iOS 26.0, *) {
                GlassEffectContainer(spacing: 20.0) {
                    HStack {
                        SearchBar(locationVM: locationVM)
                            .glassEffect(.clear)
                            .focused($isFocused)
                            .onChange(of: isFocused) {
                                appState.showOverlay = isFocused
                            }
                        
                        GpsButton(locationVM: locationVM)
                            .glassEffect(.clear)
                    }
                    .padding()
                }
            } else {
                HStack {
                    SearchBar(locationVM: locationVM)
                        .background(.white.opacity(0.4))
                        .border(.white)
                        .cornerRadius(30)
                        .focused($isFocused)
                        .onChange(of: isFocused) {
                            appState.showOverlay = isFocused
                        }
                    
                    GpsButton(locationVM: locationVM)
                }
                .padding()
            }
            if appState.showOverlay {
                CityScrollList(locationVM: locationVM, isFocused: $isFocused)
            }
        }
    }
}
