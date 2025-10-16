//
//  ContentView.swift
//  ex02
//
//  Created by jules bernard on 15.10.25.
//


import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack{
                Spacer()
                Display()
                Spacer()
                Buttons()
            }
            .navigationTitle("Calculator") // This is the current good practise for clean design instead of an AppBar
        }
    }
}

#Preview {
    ContentView()
}
