//
//  advanced_weather_appApp.swift
//  advanced_weather_app
//
//  Created by jules bernard on 11.11.25.
//

import SwiftUI


@main
struct advanced_weather_appApp: App {
    @StateObject private var appState : AppState
    @StateObject private var locationVM: LocationVM
    @StateObject private var coordinatorVM: WeatherCoordinatorVM
    
    init() {
        let appState = AppState()
        let locationVM = LocationVM(appState: appState)
        _coordinatorVM = StateObject(wrappedValue: WeatherCoordinatorVM(
            locationVM: locationVM, appState: appState))
        _locationVM = StateObject(wrappedValue: locationVM)
        _appState = StateObject(wrappedValue: appState)
    }
    
    var body: some Scene {
        WindowGroup {
            MainView(coordinatorVM: coordinatorVM, locationVM: locationVM)
            .environmentObject(appState)
        }
    }
}
