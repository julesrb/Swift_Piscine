//
//  CurrentlyView.swift
//  weather_app
//
//  Created by jules bernard on 30.10.25.
//


import SwiftUI

struct CurrentlyView: View {
    @ObservedObject var locationVM: LocationVM
    @ObservedObject var weatherVM: WeatherVM
    
    var body: some View {
        VStack {
            Spacer()
            if let weather = weatherVM.weather {
                Text(locationVM.name)
                Text(locationVM.admin1)
                Text(locationVM.country)
                
                Text("\(weather.data.current.temperature2m, specifier: "%.1f")°C")
                Text(WeatherCode(code: Int(weather.data.current.weatherCode)).description)
                Text("\(weather.data.current.windSpeed10m, specifier: "%.1f") Km/h")
            } else {
                ProgressView("Please provide an existing city or location...")
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
