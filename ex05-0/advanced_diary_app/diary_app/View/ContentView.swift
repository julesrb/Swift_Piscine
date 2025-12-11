//
//  ContentView.swift
//  diary_app
//
//  Created by jules bernard on 13.11.25.
//

import SwiftUI
import GoogleSignInSwift

enum AppScreen {
    case login
    case home
}

struct ContentView: View {
    @State var appScreen: AppScreen
    @StateObject var authVM = AuthenticationVM()

    init(initialScreen: AppScreen = .login) {
            _appScreen = State(initialValue: initialScreen)
        }
    
    var body: some View {
        ZStack {
            switch appScreen {
            case .login:
                LoginScreen(authVM: authVM, appScreen: $appScreen)
            case .home:
                HomeScreen(authVM: authVM, appScreen: $appScreen)
            }
        }
        .animation(.easeInOut, value: appScreen)
    }
}

#Preview {
    ContentView(initialScreen: .login)
        
}
