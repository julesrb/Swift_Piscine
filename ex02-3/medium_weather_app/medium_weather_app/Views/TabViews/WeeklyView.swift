//
//  WeeklyView.swift
//  weather_app
//
//  Created by jules bernard on 30.10.25.
//


import SwiftUI

struct WeeklyView: View {
    @ObservedObject var locationVM: LocationVM
    @ObservedObject var weatherVM: WeatherVM
    
    var body: some View {
        VStack {
            Spacer()
            if let weather = weatherVM.weather {
                Text(locationVM.name)
                Text(locationVM.admin1)
                Text(locationVM.country)
                
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
        .foregroundColor(.white)
        .frame(minWidth: 0, maxWidth: .infinity)
        .ignoresSafeArea(.keyboard, edges: .all)
    }
}

#Preview {
    MainView()
}
