//
//  CityBarViewModel.swift
//  weather_app
//
//  Created by jules bernard on 30.10.25.
//


import SwiftUI
import Combine

class LocationViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var midText: String = ""
    
}
