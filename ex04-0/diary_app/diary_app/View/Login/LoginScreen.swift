//
//  LoginScreen.swift
//  diary_app
//
//  Created by jules bernard on 19.11.25.
//

import SwiftUI


struct LoginScreen: View {
    @StateObject var authVM: AuthenticationVM
    @Binding var appScreen: AppScreen
    @State var startLogin: Bool = false
    
    func handleSignInGoogle() {
        Task {
            do {
                try await authVM.googleOauth()
                if authVM.user != nil {
                    print("google auth sucesufull")
                    appScreen = AppScreen.home
                }
            } catch AuthenticationError.runtimeError(let errorMessage) {
                print(errorMessage)
            }
        }
    }
    
    func handleSignInGit() {
        Task {
            do {
                try await authVM.githubOauth()
                if authVM.user != nil {
                    print("github auth sucesufull")
                    appScreen = AppScreen.home
                }
            } catch AuthenticationError.runtimeError(let errorMessage) {
                print(errorMessage)
            }
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack() {
                    VStack(alignment: .leading) {
                        Text("Diary")
                            .font(Font.custom("AbhayaLibre-Regular", size: 96))
                        Text("Your written daily\ncompanion")
                            .font(Font.custom("AbhayaLibre-Regular", size: 32))
                    }
                    .padding(.leading, 24)
                    Spacer()
                }
                .padding(.top, 125)
                Spacer()
            }
            VStack {
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Button("Login") {
                    startLogin = true
                }
                .font(Font.custom("AbhayaLibre-Regular", size: 32))
                .padding(55)
                .background(Color(red: 213/255, green: 213/255, blue: 213/255))
                .foregroundStyle(.black)
                .clipShape(Circle())
                .contentShape(Circle())
            
                if (startLogin) {
                    HStack() {
                        Button("Github") {
                            handleSignInGit()
                        }
                        .font(Font.custom("AbhayaLibre-Regular", size: 24))
                        .padding(55)
                        .background(Color(red: 77/255, green: 77/255, blue: 77/255))
                        .foregroundStyle(.white)
                        .clipShape(Circle())
                        .contentShape(Circle())              .transition(.move(edge: .trailing))
                        
                        Button("Google") {
                            handleSignInGoogle()
                        }
                        .font(Font.custom("AbhayaLibre-Regular", size: 24))
                        .padding(55)
                        .background(Color(red: 115/255, green: 187/255, blue: 254/255))
                        .foregroundStyle(.black)
                        .clipShape(Circle())
                        .contentShape(Circle())
                        .transition(.move(edge: .trailing))
                    }
                }
                Spacer()
            }
            .animation(.easeInOut, value: startLogin)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background(Color(red: 255/255, green: 249/255, blue: 243/255))
    }
}

#Preview {
    ContentView(initialScreen: .login)
}
