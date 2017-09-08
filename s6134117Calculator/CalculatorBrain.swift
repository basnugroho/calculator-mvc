//
//  CalculatorBrain.swift
//  s6134117Calculator
//
//  Created by Baskoro Nugroho on 9/8/17.
//  Copyright © 2017 Baskoro Nugroho. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var acumulator: Double?
    
    var result: Double? {
        get {
            return acumulator
        }
    }
    
    mutating func doOperation (_ symbol: String) {
        switch symbol {
        case "√":
            if let operand = acumulator {
                acumulator = sqrt(operand)
            }
            break
        case "C":
            acumulator = 0
            break
        default:
            print("default")
        }
    }
    
    mutating func setOeprand (_ operand: Double) {
        acumulator = operand
    }
    
}
