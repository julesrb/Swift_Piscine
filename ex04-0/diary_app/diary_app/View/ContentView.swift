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

struct HomeScreen: View {
    @ObservedObject var authVM: AuthenticationVM
    
    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()
            VStack {
                Text("you are in")
                    .font(.system(size: 50, design: .serif))
                Button("Sign out") {
                    Task {
                        do {
                            try await authVM.logout()
                        } catch {
                            print(error)
                        }
                    }
                }
                .font(.system(size: 20, design: .serif))
                .padding(.top, 50)
                .foregroundStyle(.white)
            }
            .padding()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .ignoresSafeArea()
        .background(.red)
    }
}


enum AuthenticationError: Error {
    case runtimeError(String)
}

struct LoginScreen: View {
    @ObservedObject var authVM: AuthenticationVM
    
    
    func handleSignInGoogle() {
        Task {
            do {
                try await authVM.googleOauth()
            } catch AuthenticationError.runtimeError(let errorMessage) {
                print(errorMessage)
            }
        }
    }
    
    func handleSignInGit() {
        Task {
            do {
                try await authVM.githubOauth()
            } catch AuthenticationError.runtimeError(let errorMessage) {
                print(errorMessage)
            }
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Notes")
                .font(.system(size: 90, design: .serif))
            Text("Welcome to your diary")
                .font(.system(.title3, design: .serif))
            
            Spacer()
            
            Button("Login with Github") {
                handleSignInGit()
            }
            .padding(15)
            .fontWeight(.bold)
            .background(.black)
            .foregroundStyle(.white)
            .cornerRadius(12)
            .padding(.bottom, 10)
            
            Button("Login with Google") {
                handleSignInGoogle()
            }
            .padding(15)
            .fontWeight(.bold)
            .background(.blue)
            .foregroundStyle(.white)
            .cornerRadius(12)
            .padding(.bottom, 10)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background(.green)
    }
}

struct ContentView: View {
    @State var appScreen: AppScreen = AppScreen.home
    @StateObject var authVM = AuthenticationVM()

    
    var body: some View {
        ZStack {
            LoginScreen(authVM: authVM)
            if (authVM.user != nil) {
                HomeScreen(authVM: authVM)
            }
        }
    }
}

#Preview {
    ContentView()
}
