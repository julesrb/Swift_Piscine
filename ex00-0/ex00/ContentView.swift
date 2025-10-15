//
//  ContentView.swift
//  ex00
//
//  Created by jules bernard on 15.10.25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Button("A simple text") {
                print("button pressed")
            }
            .padding(10)
            .background(Color.blue)
            .foregroundStyle(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
