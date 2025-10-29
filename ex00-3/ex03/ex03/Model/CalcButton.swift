//
//  CalcButton.swift
//  ex03
//
//  Created by jules bernard on 29.10.25.
//

import SwiftUI
import UIKit

enum CalcButton: String {
    case point=".", zero="0", doubleZero="00", one="1", two="2", three="3", four="4", five="5", six="6", seven="7", eight="8", nine="9"
    case plus="+", minus="-", time="*", divide="/"
    case clear="C", allClear="AC", equals="=", blank=" "
    
    var backgroundColor: Color {
        switch self {
        case .point, .zero, .doubleZero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
            return Color(UIColor.systemGray3)
        default:
            return .pink
        }
    }
    
    var type: CalcButtonType {
        switch self {
            case .zero, .doubleZero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
                return .number
            case .plus, .minus, .time, .divide:
                return .operand
            case .point:
                return .point
            case .equals:
                return .compute
            case .clear:
                return .erase
            case .allClear:
                return .eraseAll
            default:
                return .blank
        }
    }
}
