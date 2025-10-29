//
//  ContentView.swift
//  ex03bis
//
//  Created by jules bernard on 16.10.25.
//

import SwiftUI

class CoreViewModel: ObservableObject {
    @Published var expression: String = "..."
    @Published var result: String = "0"
    
    func addToExpression(_ extra: String) {
        self.expression += extra
    }
    
    func eraseOneChar() {
        
    }
    
    func eraseAllChar() {
        
    }
    
    func calculate() {
        
    }
    
    func handleCalcButton(_ char: String) {
        print("button pressed \(char)")
        
        switch char {
        case "0"..."9", ".", "+", "/", "-", "%":
            addToExpression(char)
        case "=":
            print(".")
        case "AC":
            eraseAllChar()
        case "C":
            eraseOneChar()
        default:
            break
        }
    }
}

struct Display: View {
    @ObservedObject var viewModel: CoreViewModel

    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .trailing) {
                Text(viewModel.expression)
                    .font(.system(size: 30))
                Text(viewModel.result)
                    .font(.system(size: 60, weight: .bold))
            }
            .padding()
        }
    }
}

struct Buttons: View {
    @ObservedObject var viewModel: CoreViewModel
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
                        Button(action: {viewModel.handleCalcButton(buttonText)}) {
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

struct ContentView: View {
    @StateObject var coreViewModel = CoreViewModel()
    
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
