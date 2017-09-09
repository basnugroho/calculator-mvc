//
//  CalculatorBrain.swift
//  s6134117Calculator
//
//  Created by Baskoro Nugroho on 9/8/17.
//  Copyright © 2017 Baskoro Nugroho. All rights reserved.
//

import Foundation

func changeSign (input:Double) -> Double {
    return -input
}

private struct PendingBinaryOperation {
    let function: (Double, Double)->Double
    let firsOperand: Double
    
    func perform(with secondOperand: Double)->Double {
        return function (firsOperand, secondOperand)
    }
}


struct CalculatorBrain {
    
    //private var temp: PendingBinaryOperation?
    
    private var accumulator: Double?
    
    //agar bisa func
    private enum Operation {
        case constant (Double)
        case unaryOperation ((Double) -> Double)
        case binaryOperation ((Double, Double) -> Double)
        case equals
    }
    
    private var operations: Dictionary <String, Operation> = [
        "π" : Operation.constant (Double.pi),
        "e" : Operation.constant (M_E),
        "√" : Operation.unaryOperation (sqrt),
        "cos" : Operation.unaryOperation (cos),
    ]
    
    var result: Double? {
        get {
            return accumulator
        }
    }
    
    mutating func doOperation (_ symbol: String) {
        switch symbol {
        case "√":
            if let operand = accumulator {
                accumulator = sqrt(operand)
            }
        case "C":
                accumulator = 0
        case "π":
                accumulator = Double.pi
        default:
            print ("nothing to do here")
        }
    }
    
    mutating func setOperand (_ operand: Double) {
        accumulator = operand
    }
    
}
