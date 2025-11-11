//
//  CityBarViewModel.swift
//  weather_app
//
//  Created by jules bernard on 30.10.25.
//

import SwiftUI
import Combine
import MapKit
import Contacts


class LocationVM: ObservableObject {
    @Published var searchText: String = ""
    @Published var midText: String = ""
    @Published var cityList: [City] = []
    @Published var latiLongi: [Double]?
    @Published var name: String = ""
    @Published var admin1: String = ""
    @Published var country: String = ""
    @ObservedObject var appState: AppState
    lazy var locationService = LocationService(locationVM: self)

    private var cancellables = Set<AnyCancellable>()

    init(appState: AppState) {

        self.appState = appState
        setupSearchTextReact()
    }

    func setupSearchTextReact() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.submitCitySearch()
            }
            .store(in: &cancellables)
    }

    func fetchCityList(city: String) async throws -> [City]{
        let url = URL(string: "https://geocoding-api.open-meteo.com/v1/search?name=\(city)&count=10&language=en&format=json")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let decode = try JSONDecoder().decode(Cities.self, from: data)
        return decode.results ?? []
    }

    @MainActor
    func reverseGeocode() {
        guard let loc = latiLongi else {
            print("no coordinate now")
                  return}
        let location = CLLocation(latitude: loc[0], longitude: loc[1])
        if let request = MKReverseGeocodingRequest(location: location) {
            Task {
                if let mapItem = try await request.mapItems.first {
                    if let postal = mapItem.placemark.postalAddress {
                        name = postal.city.isEmpty ? "unknown" : postal.city
                        admin1 = postal.subAdministrativeArea.isEmpty  ? "Unknown" : postal.subAdministrativeArea
                        country = postal.country.isEmpty ? "Unknown" : postal.country
                        print("\(name), \(admin1), \(country)")
                    } else {
                        print("No postal address available")
                    }
                }
            }
        } else { print("bad MKReverseGeocodingRequest") }
    }

    func submitCitySearch() {
        Task {
            do {
                let cities = try await fetchCityList(city: searchText)
                print(cities)
                cityList = cities
            } catch {
                print(error)
//                appState.appError = AppError.noConnection
//                appState.error = true
            }
        }
    }
}
