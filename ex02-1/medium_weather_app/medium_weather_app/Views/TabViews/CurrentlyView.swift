//
//  CurrentlyView.swift
//  weather_app
//
//  Created by jules bernard on 30.10.25.
//


import SwiftUI

struct CurrentlyView: View {
    @ObservedObject var cityBarViewModel: LocationViewModel
    
    var body: some View {
        VStack {
            Spacer()
            Text("Current")
                .font(.title)
                .foregroundStyle(Color.white)
            Text(cityBarViewModel.midText)
                .font(.title)
                .foregroundStyle(Color.white)
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .ignoresSafeArea(.keyboard, edges: .all)
    }
}

#Preview {
    MainView()
}
