//
//  BackgroundView.swift
//  weather_app
//
//  Created by jules bernard on 30.10.25.
//


import SwiftUI

struct BackgroundView: View {
    var body: some View {
        Image("Sky")
            .resizable()
            .scaledToFill()
            .scaleEffect(1.1)
            .ignoresSafeArea()
            .blur(radius: 16)
    }
}
