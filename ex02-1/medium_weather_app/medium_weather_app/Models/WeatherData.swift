//
//  WeatherData.swift
//  medium_weather_app
//
//  Created by jules bernard on 06.11.25.
//

import Foundation


struct WeatherData {
    let hourly: Hourly

    struct Hourly {
        let time: [Date]
        let temperature2m: [Float]
    }
}
