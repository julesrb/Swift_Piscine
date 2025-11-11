//
//  SearchOverlay.swift
//  medium_weather_app
//
//  Created by jules bernard on 06.11.25.
//

import SwiftUI


struct SearchOverlay: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        if appState.showOverlay {
            ZStack {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea()
                    .opacity(0.9)
                
                Color.black
                    .opacity(0.6)
                    .ignoresSafeArea()
            }
            .animation(.easeInOut(duration: 0.3), value: appState.showOverlay)
        }
    }
}
