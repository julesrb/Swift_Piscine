//
//  Buttons.swift
//  ex03
//
//  Created by jules bernard on 16.10.25.
//


import SwiftUI
import UIKit

struct Buttons: View {
    @ObservedObject var viewModel: CoreViewModel
    let calcButtonsArray: [[CalcButton]] =
    [[.seven, .eight, .nine, .clear, .allClear],
     [.four, .five, .six, .plus, .minus],
     [.one, .two, .three, .time, .divide],
     [.zero, .point, .doubleZero, .equals, .blank]]
    
    var body: some View {
        VStack {
            ForEach(calcButtonsArray, id: \.self) {row in
                HStack(spacing: 10) {
                    ForEach(row, id: \.self) { button in
                        Button(action: {viewModel.handleCalcButton(button)}) {
                            Text(button.rawValue)
                                .frame(maxWidth: .infinity)
                                .frame(maxHeight: 80)
                                .background(button.backgroundColor)
                                .cornerRadius(24)
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
