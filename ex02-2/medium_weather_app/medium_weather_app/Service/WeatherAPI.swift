//
//  WeatherAPI.swift
//  medium_weather_app
//
//  Created by jules bernard on 06.11.25.
//

import OpenMeteoSdk
import Foundation


class WeatherAPI {
    
    static func createWeatherData(response: WeatherApiResponse) throws -> Weather {
        guard let hourly = response.hourly else {throw WeatherAPIError.noData(string: "no hourly data")}
        guard let daily = response.daily else {throw WeatherAPIError.noData(string: "no dily data")}
        guard let current = response.current else {throw WeatherAPIError.noData(string: "no current data")}

        
        let data = WeatherData(
            current: .init(
                time: Date(timeIntervalSince1970: TimeInterval(current.time)),
                temperature2m: current.variables(at: 0)!.value,
                weatherCode: current.variables(at: 1)!.value,
                windSpeed10m: current.variables(at: 2)!.value,
                ),
            hourly: .init(
                time: hourly.getDateTime(),
                temperature2m: hourly.variables(at: 0)!.values,
                weatherCode: hourly.variables(at: 1)!.values,
                windSpeed10m: hourly.variables(at: 2)!.values,
            ),
            daily: .init(
                time: daily.getDateTime(),
                temperature2mMax: daily.variables(at: 0)!.values,
                temperature2mMin: daily.variables(at: 1)!.values,
                weatherCode: daily.variables(at: 2)!.values,
            ),
        )
        let ret = Weather(latitude: response.latitude,
                longitude: response.longitude,
                timezone: response.timezone,
                timezoneAbbreviation: response.timezoneAbbreviation,
                utcOffsetSeconds: response.utcOffsetSeconds,
                data: data)
        return ret
    }
    
    static func fetchWeather(lat: Double, longi: Double) async throws -> Weather {
        let url = URL(string: "https://api.open-meteo.com/v1/forecast?" +
                      "latitude=\(lat)" +
                      "&longitude=\(longi)" +
                      "&current=temperature_2m,weather_code,wind_speed_10m" +
                      "&hourly=temperature_2m,weather_code,wind_speed_10m" +
                      "&daily=temperature_2m_max,temperature_2m_min,weather_code" +
                      "&timezone=auto" +
                      "&format=flatbuffers")!
        let responses = try await WeatherApiResponse.fetch(url: url)
        let response = responses[0]
        
        do {
            return try createWeatherData(response: response)
        } catch {
            print("Error creating weather data:", error)
            throw error
        }
    }
}

