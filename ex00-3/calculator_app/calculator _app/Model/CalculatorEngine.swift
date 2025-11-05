//
//  CalculatorEngine.swift
//  ex03
//
//  Created by jules bernard on 29.10.25.
//

import Foundation

struct CalculatorEngine {
    
    func calculate(_ expression: String) throws -> Double {
        
        if expression.last == "+"
            || expression.last == "-"
            || expression.last == "*"
            || expression.last == "/"
            || expression.last == "." {
            throw ExpressionError.expressionError
        }
        if expression.contains("/0") {
            throw ExpressionError.divisionByZero
        }
        let expression = NSExpression(format: expression)
        guard let result: Double = expression.expressionValue(with: nil, context: nil) as? Double else {
            throw ExpressionError.invalidFormat
        }
        if result.isInfinite || result.isNaN {
            throw ExpressionError.overflow
        }
        return result
    }
}
