//
//  CityScrollList.swift
//  advanced_weather_app
//
//  Created by jules bernard on 11.11.25.
//

import SwiftUI


struct CityScrollList: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var locationVM: LocationVM
    @FocusState.Binding var isFocused: Bool
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(locationVM.cityList) { city in
                    Text("**\(city.name)** \(city.admin1), \(city.country)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(.white)
                        .padding(.bottom, 12)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            locationVM.searchText = ""
                            appState.showOverlay = false
                            locationVM.latiLongi = [city.latitude, city.longitude]
                            locationVM.name = city.name
                            locationVM.admin1 = city.admin1
                            locationVM.country = city.country
                            isFocused = false
                        }
                }
            }
            .offset(x: 35, y: 0)
        }
    }
}
