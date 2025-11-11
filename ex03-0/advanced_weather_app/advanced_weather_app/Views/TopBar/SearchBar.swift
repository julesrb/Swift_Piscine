//
//  SearchBar.swift
//  advanced_weather_app
//
//  Created by jules bernard on 11.11.25.
//

import SwiftUI


struct SearchBar: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var locationVM: LocationVM
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.white)
                .padding(.leading, 16)
                .padding(.trailing, 0)
            
            TextField("City", text: $locationVM.searchText)
                .border(.clear)
                .padding(12)
                .foregroundColor(.white)
                .onSubmit {
                    locationVM.searchText = ""
                    guard let firstCity = locationVM.cityList.first else {
                        print("No city selected")
                        appState.appError = AppError.notFound
                        appState.error = true
                        return
                    }
                    locationVM.latiLongi = [firstCity.latitude, firstCity.longitude]
                    locationVM.name = firstCity.name
                    locationVM.admin1 = firstCity.admin1
                    locationVM.country = firstCity.country
                }
        }
        .contentShape(Rectangle()) // makes the whole HStack tappable
        .onTapGesture {
            appState.showOverlay.toggle()
        }
    }
}
