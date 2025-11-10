//
//  ContentView.swift
//  weather_app
//
//  Created by jules bernard on 30.10.25.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab: Int = 0
    @StateObject private var weatherVM: WeatherVM
    @StateObject private var locationVM: LocationVM
    @State var showOverlay: Bool = false
    
    init(weatherVM: WeatherVM = WeatherVM()) {
        _weatherVM = StateObject(wrappedValue: weatherVM)
        _locationVM = StateObject(wrappedValue: LocationVM(weatherVM: weatherVM))
    }
    
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
                CurrentlyView(locationVM: locationVM, weatherVM: weatherVM)
                    .tabItem { Label("Currently", systemImage: "clock.arrow.trianglehead.2.counterclockwise.rotate.90") }
                    .tag(0)
                    .background(BackgroundView())
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                TodayView(locationVM: locationVM, weatherVM: weatherVM)
                    .tabItem { Label("Today", systemImage: "1.calendar") }
                    .tag(1)
                    .background(BackgroundView())
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                WeeklyView(locationVM: locationVM, weatherVM: weatherVM)
                    .tabItem { Label("Weekly", systemImage: "calendar") }
                    .tag(2)
                    .background(BackgroundView())
                    .ignoresSafeArea(.keyboard, edges: .bottom)
            }
            // TODO what if the city is not selected ?
            .tint(.white)
            .gesture(drag)
            SearchOverlay(showOverlay: $showOverlay)
                .onTapGesture {
                    showOverlay.toggle()
                }
            TopBarView(locationVM: locationVM, showOverlay: $showOverlay)
                .padding(.top, 0)
                .padding(.horizontal)
        }
    }
}

#Preview {
    MainView()
}
