//
//  WeatherAPI.swift
//  medium_weather_app
//
//  Created by jules bernard on 06.11.25.
//

import OpenMeteoSdk
import Foundation


class WeatherAPI {
    static func fetchWeather(lat: Double, longi: Double) async throws -> WeatherData {
        let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(longi)&hourly=temperature_2m&format=flatbuffers")!
        let responses = try await WeatherApiResponse.fetch(url: url)
        let response = responses[0]
        let utcOffsetSeconds = response.utcOffsetSeconds
        guard let hourly = response.hourly else {
            throw WeatherAPIError.noData
        }
        let utcOffset = response.utcOffsetSeconds
        let times = hourly.getDateTime(offset: utcOffset)
        var temperatures: [Float] = []
        for index in 0..<hourly.variablesCount {
                    if let hourlyData = hourly.variables(at: index) {
                        let temp = hourlyData.value
                        temperatures.append(temp)
                    }
                }
        let hourlyDataStruct = WeatherData.Hourly(time: times, temperature2m: temperatures)
        let weatherData = WeatherData(hourly: hourlyDataStruct)
        return weatherData
    }
}

