//
//  ContentView.swift
//  weather_app
//
//  Created by jules bernard on 30.10.25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 0
    
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
        TabView(selection: $selectedTab) {
            CurrentlyView()
                .tabItem { Label("Currently", systemImage: "clock.arrow.trianglehead.2.counterclockwise.rotate.90") }
                .tag(0)
            TodayView()
                .tabItem { Label("Today", systemImage: "1.calendar") }
                .tag(1)
            WeeklyView()
                .tabItem { Label("Weekly", systemImage: "calendar") }
                .tag(2)
        }
        .gesture(drag)
    }
}

#Preview {
    ContentView()
}
