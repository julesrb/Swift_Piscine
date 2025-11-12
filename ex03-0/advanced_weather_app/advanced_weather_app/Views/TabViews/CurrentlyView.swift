//
//  CurrentlyView.swift
//  weather_app
//
//  Created by jules bernard on 30.10.25.
//


import SwiftUI

struct CurrentlyView: View {
    @ObservedObject var weatherCoordinatorVM: WeatherCoordinatorVM
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text(weatherCoordinatorVM.locationVM.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("\(weatherCoordinatorVM.locationVM.admin1), \(weatherCoordinatorVM.locationVM.country)")
                        .font(.title)
                }
                .padding(.bottom, 10)
                HStack {
                    if let weather = weatherCoordinatorVM.weather {
                        let weatherCode = WeatherCode(code: Int(weather.data.current.weatherCode))
                        VStack(alignment: .leading) {
                            Text("\(weatherCode.description)\t\t\(weather.data.current.temperature2m, specifier: "%.1f")°C")
                            
                            Text("Wind\t\t\(weather.data.current.windSpeed10m, specifier: "%.1f") Km/h")
                        }
                        Spacer()
                        Image(systemName: weatherCode.symbol)
                            .font(.system(size: 50))
                        
                    } else {
                        ProgressView("Please provide an existing city or location...")
                            .foregroundColor(.white)
                    }
                }
                Spacer()
            }
            .padding()
            .padding()
        }
        .padding(.top, appState.topBarSize.height)
        .foregroundColor(.white)
        .frame(minWidth: 0, maxWidth: .infinity)
        .ignoresSafeArea(.keyboard, edges: .all)
    }
}

#Preview {
    do {
        let appState = AppState()
        let locationVM = LocationVM(appState: appState)
        let weatherCoordinatorVM = WeatherCoordinatorVM(locationVM: locationVM, appState: appState)
        locationVM.name = "Brooklyn"
        locationVM.admin1 = "New York"
        locationVM.country = "United State"
        weatherCoordinatorVM.weather = Weather(
            latitude: 37.7749,
            longitude: -122.4194,
            timezone: "America/Los_Angeles",
            timezoneAbbreviation: "PST",
            utcOffsetSeconds: -28800,
            data: WeatherData(
                current: WeatherData.Current(
                    time: Date(),
                    temperature2m: 18.5,
                    weatherCode: 2, // Partly cloudy
                    windSpeed10m: 5.4
                ),
                hourly: WeatherData.Hourly(
                    time: (0..<24).map { Calendar.current.date(byAdding: .hour, value: $0, to: Date())! },
                    temperature2m: (0..<24).map { _ in Float.random(in: 10...22) },
                    weatherCode: (0..<24).map { _ in Float([0, 1, 2, 3, 45, 61, 80].randomElement()!) },
                    windSpeed10m: (0..<24).map { _ in Float.random(in: 2...8) }
                ),
                daily: WeatherData.Daily(
                    time: (0..<7).map { Calendar.current.date(byAdding: .day, value: $0, to: Date())! },
                    temperature2mMax: (0..<7).map { _ in Float.random(in: 15...25) },
                    temperature2mMin: (0..<7).map { _ in Float.random(in: 8...14) },
                    weatherCode: (0..<7).map { _ in Float([0, 1, 2, 3, 61, 80, 95].randomElement()!) }
                )
            )
        )
        return MainView(coordinatorVM: weatherCoordinatorVM, locationVM: locationVM)
            .environmentObject(appState)
    }
}
