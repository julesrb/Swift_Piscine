//
//  Weather.swift
//  medium_weather_app
//
//  Created by jules bernard on 07.11.25.
//

import Foundation


struct Weather {
    let latitude: Float
    let longitude: Float
    let timezone: String?
    let timezoneAbbreviation: String?
    let utcOffsetSeconds: Int32
    let data: WeatherData
}

struct WeatherData {
    let current: Current
    let hourly: Hourly
    let daily: Daily

    struct Current {
        let time: Date
        let temperature2m: Float
        let weatherCode: Float
        let windSpeed10m: Float
    }
    struct Hourly {
        let time: [Date]
        let temperature2m: [Float]
        let weatherCode: [Float]
        let windSpeed10m: [Float]
    }
    struct Daily {
        let time: [Date]
        let temperature2mMax: [Float]
        let temperature2mMin: [Float]
        let weatherCode: [Float]
    }
}
