//
//  ContentView.swift
//  s00_ex00
//
//  Created by Jules BERNARD on 05.03.25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Welcome on my first app")
                .font(.title)
                .padding()
            Button("Push and that it's") {
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
