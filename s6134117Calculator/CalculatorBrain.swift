//
//  CalculatorBrain.swift
//  s6134117Calculator
//
//  Created by Baskoro Nugroho on 9/8/17.
//  Copyright © 2017 Baskoro Nugroho. All rights reserved.
//

import Foundation



private struct PendingBinaryOperation {
    
    let hitung: (Double, Double)->Double
    
    let firstOperand: Double
    
    func hajar(with secondOperand: Double)->Double {
        return hitung (firstOperand, secondOperand)
    }
    
}


func changeSign (input:Double) -> Double {
    return -input
}

func multiply (op1: Double, op2: Double)->Double {
    return op1 * op2
}

func factorial (_ n: Double) -> Double {
    return n == 0 ? 1 : n * factorial(n - 1)
}

func exponent2 (n: Double) -> Double {
    return pow(n, 2)
}

func exponent3 (n: Double) -> Double {
    return pow(n, 3)
}




var brain:CalculatorBrain = CalculatorBrain()




struct CalculatorBrain {
    
    private var tampung: PendingBinaryOperation?
    
    private var accumulator: Double?
    
    private var memory = 0.0
    
    
    var result: Double? {
        get {
            return accumulator
        }
    }
    
    var recall: Double? {
        get {
            return memory
        }
    }
    

    
    //enum, agar bisa func
    private enum Operation {
        case constant (Double)
        case generator (()->Double)
        case unaryOperation ((Double)->Double)
        case binaryOperation ((Double, Double)->Double)
        case equals
    }
    
    //dictionary
    private var operations:Dictionary <String, Operation> = [
        "π" : Operation.constant (Double.pi),
        "e" : Operation.constant (M_E),
        "C" : Operation.constant(0),
        "Rand" : Operation.generator(drand48),
        "√" : Operation.unaryOperation (sqrt),
        "sin" : Operation.unaryOperation(sin),
        "cos" : Operation.unaryOperation (cos),
        "tan" : Operation.unaryOperation(tan),
        "asin" : Operation.unaryOperation(asin),
        "acos" : Operation.unaryOperation(acos),
        "atan" : Operation.unaryOperation(atan),
        "log" : Operation.unaryOperation (log10),
        "pow2" : Operation.unaryOperation (exponent2),
        "pow3" : Operation.unaryOperation (exponent3),
        "ln" : Operation.unaryOperation(log),
        "±" : Operation.unaryOperation(changeSign),
        "%" : Operation.unaryOperation({$0/100.0}),
        "x!" : Operation.unaryOperation({(_ n: Double)->Double in return n == 0 ? 1 : n * factorial(n - 1)}),
        "x" : Operation.binaryOperation({(op1: Double, op2: Double)->Double in
                return op1 * op2
                }),
        "÷" : Operation.binaryOperation({$0 / $1}),
        "+" : Operation.binaryOperation({$0 + $1}),
        "-" : Operation.binaryOperation({$0 - $1}),
        "=" : Operation.equals
    ]
    

    
    mutating func doOperation (_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .generator(let function):
                accumulator = function()
            case .unaryOperation(let function):
                if let data = accumulator {
                    accumulator = function(data)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    tampung = PendingBinaryOperation(hitung: function, firstOperand: accumulator!)
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
            accumulator = tampung!.hajar(with: accumulator!)
            tampung = nil
        }
    }
    
    mutating func setOperand (_ operand: Double) {
        accumulator = operand
    }
    
    mutating func doMemorization (_ symbol: String, _ value: Double) {
        switch symbol {
        case "m+":
            memory = memory + value
            print(memory)
        case "m-":
            memory = memory - value
            print(memory)
        case "mc":
            memory = 0.0
            print(memory)
        case "mr":
            accumulator = memory
        default :
            print("nothing to do")
        }
    }
}
