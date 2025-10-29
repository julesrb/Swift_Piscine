//
//  CalculatorEngine.swift
//  ex03
//
//  Created by jules bernard on 29.10.25.
//

import Foundation

struct CalculatorEngine {
    
    func calculate(_ expression: String) -> Double {
        
        let expression = NSExpression(format: expression)
        if let result = expression.expressionValue(with: nil, context: nil) as? Double {
            return result
        }
        return 0
    }
    
}
