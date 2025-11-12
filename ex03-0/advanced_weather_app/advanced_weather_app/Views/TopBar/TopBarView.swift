//
//  LocationBarView.swift
//  weather_app
//
//  Created by jules bernard on 30.10.25.
//

import SwiftUI


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
        .background(
            GeometryReader { proxy in
                Color.clear
                .onAppear {
                    appState.topBarSize = proxy.size
                }
                .onChange(of: proxy.size) { oldSize, newSize in
                    appState.topBarSize = newSize
                }
            }
        )
    }
}

#Preview {
    do {
        let appState = AppState()
        let locationVM = LocationVM(appState: appState)
        let weatherCoordinatorVM = WeatherCoordinatorVM(locationVM: locationVM, appState: appState)
        locationVM.name = "Brooklyn"
        locationVM.admin1 = "New York"
        locationVM.country = "United State"
        weatherCoordinatorVM.weather = Weather(
            latitude: 37.7749,
            longitude: -122.4194,
            timezone: "America/Los_Angeles",
            timezoneAbbreviation: "PST",
            utcOffsetSeconds: -28800,
            data: WeatherData(
                current: WeatherData.Current(
                    time: Date(),
                    temperature2m: 18.5,
                    weatherCode: 2, // Partly cloudy
                    windSpeed10m: 5.4
                ),
                hourly: WeatherData.Hourly(
                    time: (0..<24).map { Calendar.current.date(byAdding: .hour, value: $0, to: Date())! },
                    temperature2m: (0..<24).map { _ in Float.random(in: 10...22) },
                    weatherCode: (0..<24).map { _ in Float([0, 1, 2, 3, 45, 61, 80].randomElement()!) },
                    windSpeed10m: (0..<24).map { _ in Float.random(in: 2...8) }
                ),
                daily: WeatherData.Daily(
                    time: (0..<7).map { Calendar.current.date(byAdding: .day, value: $0, to: Date())! },
                    temperature2mMax: (0..<7).map { _ in Float.random(in: 15...25) },
                    temperature2mMin: (0..<7).map { _ in Float.random(in: 8...14) },
                    weatherCode: (0..<7).map { _ in Float([0, 1, 2, 3, 61, 80, 95].randomElement()!) }
                )
            )
        )
        return MainView(coordinatorVM: weatherCoordinatorVM, locationVM: locationVM)
            .environmentObject(appState)
    }
}
