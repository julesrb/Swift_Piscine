//
//  WeatherCoordinator.swift
//  advanced_weather_app
//
//  Created by jules bernard on 11.11.25.
//

import SwiftUI
import Combine


class WeatherCoordinatorVM: ObservableObject {
    @Published var weather : Weather?
    @ObservedObject var locationVM: LocationVM
    @ObservedObject var appState: AppState

    private var cancellables = Set<AnyCancellable>()

    init(locationVM: LocationVM, appState: AppState) {
        self.locationVM = locationVM
        self.appState = appState
        setupReactToLocationChanges()
    }

    func setupReactToLocationChanges() {
        locationVM.$latiLongi
//            .dropFirst()
//            .removeDuplicates()
            .compactMap { $0 }
            .sink { [weak self] newValue in
                self?.startWeatherRequest(lat: newValue![0], longi: newValue![1])
                print("refresh weather loc")
            }
            .store(in: &cancellables)
    }

    func startWeatherRequest(lat: Double, longi: Double) {
        Task {
            do {
                let data = try await WeatherAPI.fetchWeather(lat: lat, longi: longi)
//                print(data)
                print("weather received")
                weather = data
            } catch {
                print("error with API call")
                appState.appError = AppError.noConnection
                appState.error = true
            }
        }
    }
}
