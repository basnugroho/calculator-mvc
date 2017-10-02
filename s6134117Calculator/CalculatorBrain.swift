//
//  CalculatorBrain.swift
//  s6134117Calculator
//
//  Created by Baskoro Nugroho on 9/8/17.
//  Copyright © 2017 Baskoro Nugroho. All rights reserved.
//

import Foundation
import CoreGraphics

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

func degToRad (_ degree: Double) -> Double {
    return degree * (Double.pi/180)
}

func sinus (number: Double, mode: Int)->Double {
    if mode != 0 { //rad mode
        return sin(number)
    }
    else {
        return sin(number * Double.pi / 180) //deg mode
    }
}

func cosinus (number: Double, mode: Int = 0)->Double {
    if mode != 0 { //rad mode
        print(mode)
        return cosinus(number: number)
    }
    return cos(number * Double.pi / 180) //deg mode
}

func tangent (number: Double, mode: Int = 0)->Double {
    if mode != 0 { //rad mode
        print(mode)
        return tangent(number: number)
    }
    return tan(number * Double.pi / 180) //deg mode
}

func asin (number: Double, mode: Int = 0)->Double {
    if mode != 0 { //rad mode
        print(mode)
        return asin(number: number)
    }
    return asin(number * Double.pi / 180) //deg mode
}
func acos (number: Double, mode: Int = 0)->Double {
    if mode != 0 { //rad mode
        print(mode)
        return acos(number: number)
    }
    return acos(number * Double.pi / 180) //deg mode
}
func atan (number: Double, mode: Int = 0)->Double {
    if mode != 0 { //rad mode
        print(mode)
        return atan(number: number)
    }
    return atan(number * Double.pi / 180) //deg mode
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
        case trigonometriOperation ((Double, Int)->Double)
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
        "sin" : Operation.trigonometriOperation(sinus),
        "cos" : Operation.trigonometriOperation(cosinus),
        "tan" : Operation.trigonometriOperation(tangent),
        "asin" : Operation.trigonometriOperation(asin),
        "acos" : Operation.trigonometriOperation(acos),
        "atan" : Operation.trigonometriOperation(atan),
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
    
    
    mutating func doOperation (_ symbol: String,_ mode: Int) {
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
            case .trigonometriOperation(let function):
                if mode == 0 { //deg
                    let degree = accumulator
                    accumulator = function(degree!, 0)
                    break
                }
                if mode == 1 {
                    let rad = accumulator
                    accumulator = function(rad!, 1) // rad
                    break
                }
                break
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
