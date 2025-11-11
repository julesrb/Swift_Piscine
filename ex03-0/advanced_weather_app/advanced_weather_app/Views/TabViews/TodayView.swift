//
//  TodayView.swift
//  weather_app
//
//  Created by jules bernard on 30.10.25.
//


import SwiftUI

struct TodayView: View {
    @ObservedObject var weatherCoordinatorVM: WeatherCoordinatorVM
    
    var body: some View {
        VStack {
            Spacer()
            ScrollView {
                Text(weatherCoordinatorVM.locationVM.name)
                Text(weatherCoordinatorVM.locationVM.admin1)
                Text(weatherCoordinatorVM.locationVM.country)
                if let weather = weatherCoordinatorVM.weather {
                    ForEach(0..<24, id: \.self) { i in
                        HStack {
                            let formatter: DateFormatter = {
                                let f = DateFormatter()
                                f.dateFormat = "HH:mm"
                                return f
                            }()
                            Text(formatter.string(from: weather.data.hourly.time[i]))
                            Text("\(weather.data.hourly.temperature2m[i], specifier: "%.1f")°C")
                            Text("\(weather.data.hourly.weatherCode[i], specifier: "%.1f")")
                            Text("\(weather.data.hourly.windSpeed10m[i], specifier: "%.1f") Km/h")
                        }
                    }
                } else {
                    ProgressView("Loading weather...")
                        .foregroundColor(.white)
                }
            }
            .padding(.top, 60)
            Spacer()
        }
        .foregroundColor(.white)
        .frame(minWidth: 0, maxWidth: .infinity)
        .ignoresSafeArea(.keyboard, edges: .all)
    }
}
