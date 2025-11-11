//
//  LocationBarView.swift
//  weather_app
//
//  Created by jules bernard on 30.10.25.
//

import SwiftUI


struct TopBarView: View {
    @ObservedObject var locationVM: LocationVM
    @FocusState private var isFocused: Bool
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack {
            if #available(iOS 26.0, *) {
                GlassEffectContainer(spacing: 20.0) {
                    HStack {
                        SearchBar(locationVM: locationVM)
                            .glassEffect(.clear)
                            .focused($isFocused)
                            .onChange(of: isFocused) {
                                appState.showOverlay = isFocused
                            }
                        
                        GpsButton(locationVM: locationVM)
                            .glassEffect(.clear)
                    }
                    .padding()
                }
            } else {
                HStack {
                    SearchBar(locationVM: locationVM)
                        .background(.white.opacity(0.4))
                        .border(.white)
                        .cornerRadius(30)
                        .focused($isFocused)
                        .onChange(of: isFocused) {
                            appState.showOverlay = isFocused
                        }
                    
                    GpsButton(locationVM: locationVM)
                }
                .padding()
            }
            if appState.showOverlay {
                CityScrollList(locationVM: locationVM, isFocused: $isFocused)
            }
        }
    }
}
