//
//  WeatherGroup.swift
//  medium_weather_app
//
//  Created by jules bernard on 10.11.25.
//

enum WeatherCode: String, CaseIterable {
    case clear
    case fog
    case drizzle
    case rain
    case snow
    case thunderstorm
    case unknown
    
    init(code: Int) {
        switch code {
        case 0, 1, 2, 3:
            self = .clear
        case 45, 48:
            self = .fog
        case 51...57:
            self = .drizzle
        case 61...67, 80...82:
            self = .rain
        case 71...77, 85...86:
            self = .snow
        case 95, 96, 99:
            self = .thunderstorm
        default:
            self = .unknown
        }
    }
    
    var description: String {
        switch self {
        case .clear: return "Clear"
        case .fog: return "Foggy"
        case .drizzle: return "Drizzle"
        case .rain: return "Rainy"
        case .snow: return "Snowy"
        case .thunderstorm: return "Thunderstorm"
        case .unknown: return "Unknown"
        }
    }
    
    var symbol: String {
        switch self {
        case .clear: return "sun.max.fill"
        case .fog: return "cloud.fog.fill"
        case .drizzle: return "cloud.drizzle.fill"
        case .rain: return "cloud.rain.fill"
        case .snow: return "cloud.snow.fill"
        case .thunderstorm: return "cloud.bolt.rain.fill"
        case .unknown: return "sparkles.fill"
        }
    }
}
