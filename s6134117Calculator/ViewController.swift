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
    
    var userIsTyping: Bool = false
    
    var DisplayValue:Double {
        get {
            return Double(displayLabel.text!)!
        }
        set {
            displayLabel.text = String(newValue)
        }
    }
    
    @IBAction func doOperation(_ sender: UIButton) {
        //baru
        if userIsTyping {
            brain.setOeprand(DisplayValue)
            userIsTyping = false
        }
        
        if let operationSymbol = sender.currentTitle {
            brain.doOperation(operationSymbol)
        }
        
        if let result = brain.result {
            DisplayValue = result
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

