//
//  ContentView.swift
//  s00_ex00
//
//  Created by Jules BERNARD on 05.03.25.
//

import SwiftUI

struct ContentView: View {
    @State private var text = "Welcome to my first app"
    var body: some View {
        VStack {
            Text(text)
                .font(.title)
                .padding()
            Button("Push and that it's") {
                if text == "Welcome to my first app" {
                    text = "Hello World!"
                } else {
                    text = "Welcome to my first app"
                }
                print("Button pressed")
            }
            .padding()
            .background(Color.blue)
            .foregroundStyle(Color.white)
            .cornerRadius(10)
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
