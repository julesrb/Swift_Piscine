//
//  ContentView.swift
//  weather_app
//
//  Created by jules bernard on 30.10.25.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab: Int = 0
    @StateObject private var cityBarViewModel = LocationViewModel()
    
    var drag: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onEnded({value in
                if value.translation.width < 0 {
                    selectedTab = min(selectedTab + 1, 2)
                }
                if value.translation.width > 0 {
                    selectedTab = max(selectedTab - 1, 0)
                }
            })
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            TabView(selection: $selectedTab) {
                CurrentlyView(cityBarViewModel: cityBarViewModel)
                    .tabItem { Label("Currently", systemImage: "clock.arrow.trianglehead.2.counterclockwise.rotate.90") }
                    .tag(0)
                    .background(BackgroundView())
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                TodayView(cityBarViewModel: cityBarViewModel)
                    .tabItem { Label("Today", systemImage: "1.calendar") }
                    .tag(1)
                    .background(BackgroundView())
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                WeeklyView(cityBarViewModel: cityBarViewModel)
                    .tabItem { Label("Weekly", systemImage: "calendar") }
                    .tag(2)
                    .background(BackgroundView())
                    .ignoresSafeArea(.keyboard, edges: .bottom)
            }
            .tint(.white)
            .gesture(drag)
            TopBarView(cityBarViewModel: cityBarViewModel)
                .padding(.top, 0)
                .padding(.horizontal)
        }
    }
}

#Preview {
    MainView()
}
