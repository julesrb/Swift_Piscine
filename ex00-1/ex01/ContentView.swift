//
//  ContentView.swift
//  ex00
//
//  Created by jules bernard on 15.10.25.
//

import SwiftUI

struct ContentView: View {
    @State private var buttonBinarySwitch: Bool = true
    

    var body: some View {
        VStack {
            Button(buttonBinarySwitch ? "A simple text" : "hello world!") {
                buttonBinarySwitch.toggle()
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
