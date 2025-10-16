//
//  Buttons.swift
//  ex02
//
//  Created by jules bernard on 16.10.25.
//


import SwiftUI

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
                                .font(.system(size: 24))
                        }
                        .buttonStyle(.plain)
                        
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
