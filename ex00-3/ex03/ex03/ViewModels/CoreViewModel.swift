//
//  CoreViewModel.swift
//  ex03
//
//  Created by jules bernard on 29.10.25.
//


import Foundation

class CoreViewModel: ObservableObject {
    @Published var expression: String = ""
    @Published var result: String = "0"
    
    private let engine = CalculatorEngine()
    
    func addToExpression(_ extra: String) {
        expression += extra
    }
    
    func eraseOneChar() {
        if !expression.isEmpty {
            expression.removeLast()
        }
    }
    
    func eraseAllChar() {
        if !expression.isEmpty {
            expression.removeAll()
        }
    }
    
    func calculate() {
        result = String(engine.calculate(expression))
        expression.removeAll()
    }
    
    func handleCalcButton(_ button: CalcButton) {
        
        switch button.type {
            case .number:
                addToExpression(button.rawValue)
            case .operand, .point:
                if (button == .minus) {
                    addToExpression(button.rawValue)
                }
                else if (expression.last != "+" && expression.last != "-" && expression.last != "*" && expression.last != "/" && expression.last != ".") {
                    addToExpression(button.rawValue)
                }
            case .compute:
                calculate()
            case .erase:
                eraseOneChar()
            case .eraseAll:
                eraseAllChar()
            default:
                break
        }
    }
}


