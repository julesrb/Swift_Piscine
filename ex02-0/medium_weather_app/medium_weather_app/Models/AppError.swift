//
//  AppError.swift
//  medium_weather_app
//
//  Created by jules bernard on 10.11.25.
//

enum AppError: String {
    case notFound
    case noConnection
    case noError
    
    var descritpion: String {
        switch self {
        case .notFound: return "Could not find result for this location"
        case .noConnection: return "The service connection is lost, try again later"
        case .noError: return "No error"
        }
    }
}


