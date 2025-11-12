//
//  WeeklyView.swift
//  weather_app
//
//  Created by jules bernard on 30.10.25.
//


import SwiftUI

struct WeeklyView: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var weatherCoordinatorVM: WeatherCoordinatorVM
    
    var body: some View {
        VStack {
            Spacer()
            Text(weatherCoordinatorVM.locationVM.name)
            Text(weatherCoordinatorVM.locationVM.admin1)
            Text(weatherCoordinatorVM.locationVM.country)
            if let weather = weatherCoordinatorVM.weather {
                ForEach(0..<weather.data.daily.time.count, id: \.self) { i in
                    HStack {
                        let formatter: DateFormatter = {
                            let f = DateFormatter()
                            f.dateFormat = "yyyy-MM-dd"
                            return f
                        }()
                        Text(formatter.string(from: weather.data.hourly.time[i]))
                        Text("\(weather.data.daily.temperature2mMax[i], specifier: "%.1f")°C")
                        Text("\(weather.data.daily.temperature2mMin[i], specifier: "%.1f")°C")
                        Text(WeatherCode(code: Int(weather.data.daily.weatherCode[i])).description)
                    }
                }
            } else {
                ProgressView("Loading weather...")
                    .foregroundColor(.white)
            }
            Spacer()
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
