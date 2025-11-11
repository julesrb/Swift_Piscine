//
//  advanced_weather_appApp.swift
//  advanced_weather_app
//
//  Created by jules bernard on 11.11.25.
//

import SwiftUI

@main
struct advanced_weather_appApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var weatherVM: WeatherVM
    @StateObject private var locationVM: LocationVM
    
    init() {
            let weather = WeatherVM()
            _weatherVM = StateObject(wrappedValue: weather)
            _locationVM = StateObject(wrappedValue: LocationVM(weatherVM: weather))
        }
    
    var body: some Scene {
        WindowGroup {
            MainView(weatherVM: weatherVM, locationVM: locationVM)
            .environmentObject(appState)
        }
    }
}
