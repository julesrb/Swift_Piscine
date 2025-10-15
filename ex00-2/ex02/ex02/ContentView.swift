//
//  ContentView.swift
//  ex02
//
//  Created by jules bernard on 15.10.25.
//

import SwiftUI

struct Display: View {
    @State var expression = "...+...-.../...*...?"
    @State var result = "0"

    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .trailing) {
                Text(expression)
                    .font(.system(size: 30))
                Text(result)
                    .font(.system(size: 40, weight: .bold))
            }
            .padding()
        }
    }
}

struct Buttons: View {
    let calcButtonsArray: [[String]] =
    [["7", "8", "9", "C", "AC"],
     ["4", "5", "6", "+", "-"],
     ["1", "2", "3", "*", "/"],
     ["0", ".", "00", "=", " "]]
    
    var body: some View {
        VStack {
            ForEach(calcButtonsArray, id: \.self) {row in
                HStack(spacing: 10) {
                    ForEach(row, id: \.self) { buttonText in
                        Button(action: {print("button pressed \(buttonText)")}) {
                            Text(buttonText)
                                .frame(maxWidth: .infinity)
                                .frame(maxHeight: 80)
                                .background(Color.orange)
                                .foregroundStyle(Color.black)
                                .cornerRadius(12)
                        }
                        .buttonStyle(.plain)
                    }
                }
                
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            NavigationStack {
                Spacer()
                Display()
                Spacer()
                Buttons()
                .navigationTitle("Calculator") // This is the current good practise for clean design instead of an AppBar
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
//    Display()
//    Buttons()
}
