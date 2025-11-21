//
//  Cities.swift
//  medium_weather_app
//
//  Created by jules bernard on 06.11.25.
//

import Foundation

struct Cities: Decodable {
    let results: [City]?
}

struct City: Decodable, Identifiable, Hashable {
    // Use a stable synthetic id derived from unique fields.
    var id: String { "\(name)|\(latitude)|\(longitude)" }

    let name: String
    let country: String
    let latitude: Double
    let longitude: Double
    let admin1: String
}

