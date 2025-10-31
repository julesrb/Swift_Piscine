//
//  LocationBarView.swift
//  weather_app
//
//  Created by jules bernard on 30.10.25.
//

import SwiftUI

struct SearchBar: View {
    @ObservedObject var cityBarViewModel: CityBarViewModel
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.white)
                .padding(.leading, 16)
                .padding(.trailing, 0)
            
            TextField("City", text: $cityBarViewModel.text)
                .border(.clear)
                .padding(12)
                .foregroundColor(.white)
        }
    }
}

struct GpsButton: View {
    @ObservedObject var cityBarViewModel: CityBarViewModel
    var body: some View {
        Button(action: {cityBarViewModel.text = "Geolocation"}) {
            Image(systemName: "location.fill")
                .imageScale(.large)
                .foregroundColor(.white)
                .padding(9)
                .opacity(0.8)
        }
    }
}


struct TopBarView: View {
    @ObservedObject var cityBarViewModel: CityBarViewModel
    var body: some View {
        
        if #available(iOS 26.0, *) {
            GlassEffectContainer(spacing: 20.0) {
                HStack {
                    SearchBar(cityBarViewModel: cityBarViewModel)
                        .glassEffect(.clear)
                    
                    GpsButton(cityBarViewModel: cityBarViewModel)
                        .glassEffect(.clear)
                }
                .padding()
            }
        } else {
            HStack {
                SearchBar(cityBarViewModel: cityBarViewModel)
                    .background(.white.opacity(0.4))
                    .border(.white)
                    .cornerRadius(30)
                
                GpsButton(cityBarViewModel: cityBarViewModel)
            }
            .padding()
        }
    }
}

#Preview {
    MainView()
}
