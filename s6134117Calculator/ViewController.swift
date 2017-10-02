//
//  ViewController.swift
//  s6134117Calculator
//
//  Created by Baskoro Nugroho on 8/25/17.
//  Copyright © 2017 Baskoro Nugroho. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var brain:CalculatorBrain = CalculatorBrain()
    
    var userIsTyping:Bool = false
    
    enum CalculatorModes {
        case deg,rad
    }
    
    var calculatorMode = CalculatorModes.deg
    
    var displayValue:Double {
        get {
            return Double(displayLabel.text!)!
        }
        set {
            displayLabel.text = String(newValue)
        }
    }
    
    @IBOutlet weak var radDegInfoLabel: UILabel!
    
    @IBOutlet weak var radDegButton: UIButton!
    
    @IBAction func doToggleRadDeg(_ sender: Any) {
        if calculatorMode == CalculatorModes.deg {
            calculatorMode = CalculatorModes.rad
            radDegInfoLabel.text = "rad"
            radDegButton.setTitle("deg", for: .normal)
        } else {
            calculatorMode = CalculatorModes.deg
            radDegInfoLabel.text = "deg"
            radDegButton.setTitle("rad", for: .normal)
        }
    }
    
    @IBAction func doMemorization(_ sender: UIButton) {
        
        if let memorySymbol = sender.currentTitle {
            brain.doMemorization(memorySymbol, displayValue)
        }
        
        if let result = brain.result {
            displayValue = result
        }
    }
    
    
    //operator or accumulator button
    @IBAction func doOperation(_ sender: UIButton) {
        //baru
        if userIsTyping {
            brain.setOperand(displayValue)
            userIsTyping = false
        }
        
        if let operationSymbol = sender.currentTitle {

            if calculatorMode == CalculatorModes.rad {
                brain.doOperation(operationSymbol, 1)
            } else {
                brain.doOperation(operationSymbol, 0)
            }
        }
        
        if let result = brain.result {
            displayValue = result
        }
        
        //lama pindah ke brain
//        if let operationSymbol = sender.currentTitle {
//            switch operationSymbol {
//            case "√":
//                DisplayValue = sqrt(DisplayValue)
//            case "C":
//                DisplayValue = 0
//            default:
//                print("Nothing to do here")
//            }
//        }
        
    }

    
    @IBOutlet weak var displayLabel: UILabel!
    
    //digit button
    @IBAction func showDigit(_ sender: UIButton) {
        if userIsTyping {
            let digit = sender.currentTitle!
            let currentText = displayLabel.text!
            displayLabel.text = currentText + digit
        }
        else {
            let digit = sender.currentTitle!
            displayLabel.text = digit
            userIsTyping = true
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

