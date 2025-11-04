//
//  WeeklyView.swift
//  weather_app
//
//  Created by jules bernard on 30.10.25.
//


import SwiftUI

struct WeeklyView: View {
    @ObservedObject var cityBarViewModel: CityBarViewModel
    
    var body: some View {
        VStack {
            Spacer()
            Text("Weekly")
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
