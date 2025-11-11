//
//  BackgroundView.swift
//  weather_app
//
//  Created by jules bernard on 30.10.25.
//


import SwiftUI

struct BackgroundView: View {
    var body: some View {
        Image("orange")
            .resizable()
            .scaledToFill()
            .scaleEffect(1.1)
            .ignoresSafeArea()
            .frame(minWidth: 0, maxWidth: .infinity)
//            .blur(radius: 16)
    }
}

