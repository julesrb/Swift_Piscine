//
//  AppState.swift
//  medium_weather_app
//
//  Created by jules bernard on 10.11.25.
//

import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var error: Bool = false
    @Published var appError: AppError = .noError
    @Published var selectedTab: Int = 0
    @Published var showOverlay: Bool = false
}
