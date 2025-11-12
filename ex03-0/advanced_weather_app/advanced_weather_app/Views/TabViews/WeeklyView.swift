//
//  WeeklyView.swift
//  weather_app
//
//  Created by jules bernard on 30.10.25.
//


import SwiftUI
import Charts

struct TempPoint: Identifiable {
    let id = UUID()
    let date: Date
    let min: Float
    let max: Float
}

struct WeeklyView: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var weatherCoordinatorVM: WeatherCoordinatorVM
    
    var body: some View {
        let formatterDDD: DateFormatter = {
            let f = DateFormatter()
            f.dateFormat = "EEE d"
            return f
        }()
        let formatterD: DateFormatter = {
            let f = DateFormatter()
            f.dateFormat = "d"
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
                            
                            
                            let points: [TempPoint] = (0..<7).map { i in
                                TempPoint(
                                    date: weather.data.daily.time[i],
                                    min: weather.data.daily.temperature2mMin[i],
                                    max: weather.data.daily.temperature2mMax[i]
                                )
                            }
                            Chart {
                                // MIN series
                                ForEach(points) { point in
                                    LineMark(
                                        x: .value("Hours", point.date),
                                        y: .value("Temperature", point.min)
                                    )
                                }
                                .foregroundStyle(by: .value("Type", "Min"))
                                .lineStyle(StrokeStyle(lineWidth: 2))

                                // MAX series
                                ForEach(points) { point in
                                    LineMark(
                                        x: .value("Hours", point.date),
                                        y: .value("Temperature", point.max)
                                    )
                                }
                                .foregroundStyle(by: .value("Type", "Max"))
                                .lineStyle(StrokeStyle(lineWidth: 2))
                            }
                            .chartForegroundStyleScale([
                                "Min": .white.opacity(0.5),
                                "Max": .white
                            ])
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
                                AxisMarks(values: .stride(by: .day, count: 1)) { value in
                                    AxisValueLabel{
                                        if let date = value.as(Date.self) {
                                            Text(formatterD.string(from: date))
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
                            .chartLegend(.hidden)
                            HStack(spacing: 20) {
                                HStack(spacing: 6) {
                                    Rectangle()
                                        .fill(Color.white.opacity(0.5))
                                        .frame(width: 24, height: 2)
                                    Text("Min")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }
                                HStack(spacing: 6) {
                                    Rectangle()
                                        .fill(Color.white)
                                        .frame(width: 24, height: 2)
                                    Text("Max")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.bottom, 8)
                        }
                    }
                    .background(Color.black.opacity(0.4))
                    .cornerRadius(20)
                    .frame(height: 250)
                    .padding(.bottom, 10)

                    if let weather = weatherCoordinatorVM.weather {
                        VStack {
                        ForEach(0..<7, id: \.self) { i in
                            HStack {
                                HStack {
                                    let weatherCode = WeatherCode(code: Int(weather.data.daily.weatherCode[i]))
                                    VStack {
                                        Text("\(formatterDDD.string(from: weather.data.daily.time[i]))   \t")
                                            .fontWeight(.bold)
                                        Spacer()
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        Text("Min \t \(weather.data.daily.temperature2mMin[i], specifier: "%.1f")°C")
                                        
                                        Text("Max\t \(weather.data.daily.temperature2mMax[i], specifier: "%.1f")°C")
                                    }
                                    Spacer()
                                    VStack {
                                        Image(systemName: weatherCode.symbol)
                                            .font(.system(size: 30))
                                        Spacer()
                                    }
                                }
//                                .padding()
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
        appState.selectedTab = 2
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
