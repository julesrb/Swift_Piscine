//
//  ContentView.swift
//  weather_app
//
//  Created by jules bernard on 30.10.25.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var weatherVM: WeatherVM
    @ObservedObject var locationVM: LocationVM
    @State var showOverlay: Bool = false

    var drag: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onEnded({value in
                if value.translation.width < 0 {
                    appState.selectedTab = min(appState.selectedTab + 1, 2)
                }
                if value.translation.width > 0 {
                    appState.selectedTab = max(appState.selectedTab - 1, 0)
                }
            })
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            TabView(selection: $appState.selectedTab) {
                CurrentlyView(locationVM: locationVM, weatherVM: weatherVM)
                    .tabItem { Label("Currently",systemImage: "clock.arrow.trianglehead.2.counterclockwise.rotate.90") }
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
            .tint(.white)
            .gesture(drag)
            .alert(
                "App error",
                isPresented: $appState.error
            ) {} message: {
                Text(appState.appError.descritpion)
            }
            SearchOverlay()
                .onTapGesture {
                    appState.showOverlay.toggle()
                }
                
            TopBarView(locationVM: locationVM, showOverlay: $showOverlay)
                .padding(.top, 0)
                .padding(.horizontal)
                .environmentObject(appState)
                .onAppear { weatherVM.appState = appState }
                .onAppear { locationVM.appState = appState }
        }
    }
}

#Preview {
    let appState = AppState()
    let weatherVM = WeatherVM()
    let locationVM = LocationVM(weatherVM: weatherVM)
    return MainView(weatherVM: weatherVM, locationVM: locationVM)
        .environmentObject(appState)
}
