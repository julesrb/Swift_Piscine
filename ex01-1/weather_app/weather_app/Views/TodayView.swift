//
//  TodayView.swift
//  weather_app
//
//  Created by jules bernard on 30.10.25.
//


import SwiftUI

struct TodayView: View {
    @ObservedObject var cityBarViewModel: CityBarViewModel
    
    var body: some View {
        VStack {
            Spacer()
            Text("Today")
                .font(.title)
                .foregroundStyle(Color.white)
            Text(cityBarViewModel.text)
                .font(.title)
                .foregroundStyle(Color.white)
            Spacer()
        }
        .ignoresSafeArea(.keyboard, edges: .all)
    }
}
