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
    let firstOperand: Double
    
    func perform(with secondOperand: Double)->Double {
        return function (firstOperand, secondOperand)
    }
    
}

func multiply (op1: Double, op2: Double)->Double {
    return op1 * op2
}


struct CalculatorBrain {
    
    private var tampung: PendingBinaryOperation?
    
    private var accumulator: Double?
    
    //agar bisa func
    private enum Operation {
        case constant (Double)
        case unaryOperation ((Double)->Double)
        case binaryOperation ((Double, Double)->Double)
        case equals
    }
    
    //dictionary
    private var operations: Dictionary <String, Operation> = [
        "π" : Operation.constant (Double.pi),
        "e" : Operation.constant (M_E),
        "√" : Operation.unaryOperation (sqrt),
        "cos" : Operation.unaryOperation (cos),
        "±" : Operation.unaryOperation(changeSign),
        "x" : Operation.binaryOperation({(op1: Double, op2: Double)->Double in
            return op1 * op2
        }),
        "=" : Operation.equals
    ]
    
    var result: Double? {
        get {
            return accumulator
        }
    }
    
    mutating func doOperation (_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if let data = accumulator {
                    accumulator = function(data)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    tampung = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
                break
            case .equals:
                doPendingBinaryOperation()
                break
            }
        }
    }
    
    mutating func doPendingBinaryOperation() {
        if(tampung != nil && accumulator != nil) {
            accumulator = tampung!.perform(with: accumulator!)
            tampung = nil
        }
    }
    
    mutating func setOperand (_ operand: Double) {
        accumulator = operand
    }
    
}
