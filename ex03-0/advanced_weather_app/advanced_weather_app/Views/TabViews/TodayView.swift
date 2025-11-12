//
//  TodayView.swift
//  weather_app
//
//  Created by jules bernard on 30.10.25.
//


import SwiftUI
import Charts

struct TodayView: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var weatherCoordinatorVM: WeatherCoordinatorVM
    
    var body: some View {
        let formatter: DateFormatter = {
            let f = DateFormatter()
            f.dateFormat = "HH:mm"
            return f
        }()
        let formatterHH: DateFormatter = {
            let f = DateFormatter()
            f.dateFormat = "HH"
            return f
        }()
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    if (weatherCoordinatorVM.locationVM.name != "") {
                        VStack(alignment: .leading) {
                            Text(weatherCoordinatorVM.locationVM.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Text("\(weatherCoordinatorVM.locationVM.admin1),  \(weatherCoordinatorVM.locationVM.country)")
                                .font(.title)
                        }
                        .padding(.bottom, 16)
                    }
                    VStack {
                        if let weather = weatherCoordinatorVM.weather {
                            Chart {
                                ForEach(0..<24, id: \.self) { i in
                                    LineMark(
                                        x: .value("Hours",  weather.data.hourly.time[i]),
                                        y: .value("Temperature", weather.data.hourly.temperature2m[i])
                                    )
                                    
                                }
                            }
                            .chartYAxis {
                                AxisMarks(values: .automatic(desiredCount: 4)) { value in
                                    AxisValueLabel{
                                        if let temp = value.as(Int.self) {
                                            Text("\(temp) °C")
                                                .font(.caption2)
                                                .foregroundColor(.white)
                                        }
                                    }
                                    AxisGridLine()
                                        .foregroundStyle(Color.white.opacity(0.6))
                                }
                            }
                            .chartXAxis {
                                AxisMarks(values: .stride(by: .hour, count: 4)) { value in
                                    AxisValueLabel{
                                        if let date = value.as(Date.self) {
                                            Text(formatterHH.string(from: date))
                                                .font(.caption2)
                                                .foregroundColor(.white)
                                        }
                                    }
                                    AxisGridLine()
                                        .foregroundStyle(Color.white.opacity(0.6))
                                }
                            }
                            .padding()
                            .padding(.top, 16)
                        }
                    }
                    .background(Color.black.opacity(0.4))
                    .cornerRadius(20)
                    .frame(height: 250)
                    .padding(.bottom, 10)
                    VStack {
                        if let weather = weatherCoordinatorVM.weather {
                            VStack {
                                ForEach(0..<24, id: \.self) { i in
                                    HStack {
                                        HStack {
                                            let weatherCode = WeatherCode(code: Int(weather.data.hourly.weatherCode[i]))
                                            VStack {
                                                Text("\(formatter.string(from: weather.data.hourly.time[i]))\t\t")
                                                    .fontWeight(.bold)
                                                Spacer()
                                            }
                                            
                                            VStack(alignment: .leading) {
                                                Text("\(weatherCode.description)\t \(weather.data.hourly.temperature2m[i], specifier: "%.1f")°C")
                                                
                                                Text("Wind\t \(weather.data.hourly.windSpeed10m[i], specifier: "%.1f") Km/h")
                                            }
                                            Spacer()
                                            VStack {
                                                Image(systemName: weatherCode.symbol)
                                                    .font(.system(size: 30))
                                                Spacer()
                                            }
                                        }
                                        
                                    }
                                }
                                .padding()
                                .background(Color.black.opacity(0.4))
                                .cornerRadius(20)
                            }
                        } else {
                            ProgressView("Loading weather...")
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding()
                .padding()
            }
            Spacer()
        }
        .padding(.top, appState.topBarSize.height - 5)
        .foregroundColor(.white)
        .frame(minWidth: 0, maxWidth: .infinity)
        .ignoresSafeArea(.keyboard, edges: .all)
    }
}

#Preview {
    do {
        let appState = AppState()
        appState.selectedTab = 1
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
