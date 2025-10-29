//
//  ContentView.swift
//  ex03
//
//  Created by jules bernard on 15.10.25.
//


import SwiftUI

struct ContentView: View {
    @StateObject private var coreViewModel = CoreViewModel()
    
    var body: some View {
        NavigationStack {   
            VStack{
                Spacer()
                Display(viewModel: coreViewModel)
                Spacer()
                Buttons(viewModel: coreViewModel)
            }
            .navigationTitle("Calculator") // This is the current good practise for clean design instead of an AppBar
        }
    }
}

#Preview {
    ContentView()
}
