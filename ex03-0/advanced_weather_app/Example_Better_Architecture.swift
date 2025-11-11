// Example: Better architecture with protocols and coordinator
// This is just for reference - not meant to be compiled

import Foundation
import Combine
import CoreLocation

// MARK: - Protocols for Decoupling

protocol LocationProviding {
    var currentLocation: AnyPublisher<CLLocationCoordinate2D, Never> { get }
    func requestLocation()
    func requestAuthorization()
}

protocol WeatherFetching {
    func fetchWeather(lat: Double, long: Double) async throws -> Weather
}

// MARK: - Coordinator (manages the flow between location and weather)

class WeatherCoordinator: ObservableObject {
    @Published var weather: Weather?
    @Published var currentLocation: String = ""

    private let locationProvider: LocationProviding
    private let weatherService: WeatherFetching
    private var cancellables = Set<AnyCancellable>()

    init(locationProvider: LocationProviding, weatherService: WeatherFetching) {
        self.locationProvider = locationProvider
        self.weatherService = weatherService

        setupBindings()
    }

    private func setupBindings() {
        // When location changes, automatically fetch weather
        locationProvider.currentLocation
            .sink { [weak self] coordinate in
                Task {
                    await self?.fetchWeatherForCoordinate(coordinate)
                }
            }
            .store(in: &cancellables)
    }

    func fetchWeatherForCoordinate(_ coordinate: CLLocationCoordinate2D) async {
        do {
            weather = try await weatherService.fetchWeather(
                lat: coordinate.latitude,
                long: coordinate.longitude
            )
        } catch {
            // Handle error
        }
    }
}

// MARK: - ViewModels (now simpler and focused)

class LocationViewModel: ObservableObject, LocationProviding {
    @Published var searchText = ""
    @Published var cityList: [City] = []

    private let currentLocationSubject = PassthroughSubject<CLLocationCoordinate2D, Never>()
    private let locationService = CLLocationManager()
    private var cancellables = Set<AnyCancellable>()

    var currentLocation: AnyPublisher<CLLocationCoordinate2D, Never> {
        currentLocationSubject.eraseToAnyPublisher()
    }

    init() {
        setupSearchDebounce()
    }

    private func setupSearchDebounce() {
        $searchText
            .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                Task {
                    await self?.searchCities(text)
                }
            }
            .store(in: &cancellables)
    }

    func requestLocation() {
        // Location logic
    }

    func requestAuthorization() {
        // Authorization logic
    }

    private func searchCities(_ query: String) async {
        // City search logic
    }
}

class WeatherViewModel: ObservableObject, WeatherFetching {
    @Published var weather: Weather?

    func fetchWeather(lat: Double, long: Double) async throws -> Weather {
        // API call
        return try await WeatherAPI.fetchWeather(lat: lat, longi: long)
    }
}

// MARK: - View Usage

struct ImprovedMainView: View {
    @StateObject private var coordinator: WeatherCoordinator
    @StateObject private var locationVM = LocationViewModel()
    @StateObject private var weatherVM = WeatherViewModel()

    init() {
        let locationVM = LocationViewModel()
        let weatherVM = WeatherViewModel()

        _coordinator = StateObject(wrappedValue: WeatherCoordinator(
            locationProvider: locationVM,
            weatherService: weatherVM
        ))

        _locationVM = StateObject(wrappedValue: locationVM)
        _weatherVM = StateObject(wrappedValue: weatherVM)
    }

    var body: some View {
        // Use coordinator.weather instead of weatherVM.weather
        Text("Weather: \(coordinator.weather?.current.temperature ?? 0)")
    }
}

// MARK: - Benefits of This Approach

/*
 ✅ No circular dependencies
 ✅ Each ViewModel has single responsibility
 ✅ Easy to test (inject mock LocationProviding/WeatherFetching)
 ✅ Coordinator manages the "flow" logic
 ✅ ViewModels don't know about each other
 ✅ Can swap implementations easily
 */
