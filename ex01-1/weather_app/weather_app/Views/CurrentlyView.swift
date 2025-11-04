//
//  CurrentlyView.swift
//  weather_app
//
//  Created by jules bernard on 30.10.25.
//


import SwiftUI

struct CurrentlyView: View {
    @ObservedObject var cityBarViewModel: CityBarViewModel
    
    var body: some View {
        VStack {
            Spacer()
            Text("Current")
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

#Preview {
    MainView()
}
