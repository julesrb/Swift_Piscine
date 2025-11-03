//
//  CalculatorEngine.swift
//  ex03
//
//  Created by jules bernard on 29.10.25.
//

import Foundation

enum ExpressionError: Error {
    case overflow
}

struct CalculatorEngine {
    
    func calculate(_ expression: String) throws -> Double {
        
        do {
            let expression = NSExpression(format: expression)
            if let result = expression.expressionValue(with: nil, context: nil) as? Double {
                if result.isInfinite || result.isNaN {
                    throw ExpressionError.overflow
                }
                return result
        }
        } catch {
            throw ExpressionError.overflow
        }

        return 0
    }
    
}
