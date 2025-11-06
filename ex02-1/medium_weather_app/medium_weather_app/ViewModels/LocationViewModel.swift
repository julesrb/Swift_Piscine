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
    @Published var cityList: [City] = []
    
    private var cancellables = Set<AnyCancellable>()

        init() {
            // Subscribe to searchText changes
            $searchText
                .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
                .removeDuplicates()
                .sink { [weak self] newText in
                    self?.submitSearch()
                }
                .store(in: &cancellables)
        }
    
    func fetchCities(city: String) async throws -> [City]{
        let url = URL(string: "https://geocoding-api.open-meteo.com/v1/search?name=\(city)&count=10&language=en&format=json")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let decode = try JSONDecoder().decode(Cities.self, from: data)
        return decode.results ?? []
    }
    
    func submitSearch() {
        midText = searchText
        Task {
            do {
                let cities = try await fetchCities(city: searchText)
                print(cities)
                cityList = cities
            } catch {
                print(error)
            }
        }
    }
}
