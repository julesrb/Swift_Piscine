//
//  WeatherVM.swift
//  medium_weather_app
//
//  Created by jules bernard on 07.11.25.
//

import SwiftUI
import Combine


class WeatherVM: ObservableObject {
    @Published var weather : Weather?
    
    func startWeatherRequest(lat: Double, longi: Double) {
        Task {
            do {
                let data = try await WeatherAPI.fetchWeather(lat: lat, longi: longi)
                print(data)
                weather = data
            } catch {
                print("error with API call")
            }
        }
    }
}
