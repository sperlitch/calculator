//
//  ViewController.swift
//  Calculator
//
//  Created by Scott Perlitch on 10/2/15.
//  Copyright © 2015 Scott Perlitch. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var userBegin = true
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        print("digit = \(digit)")
        if userBegin {
            display.text = digit
            userBegin = false
        } else {
            display.text = display.text! + digit
        }
        
    }
    
    @IBAction func operate(sender: UIButton) {
        // Figure out who is sending
        let mathSymbol = sender.currentTitle!
        
        if userBegin == false {
            enter()
        }
        
        switch mathSymbol {
            // pass function
            case "✖️": performOperation { $0 * $1 } // only argument, last argument
            case "➗": performOperation { $1 / $0 }
            case "➕": performOperation { $0 + $1 }
            case "➖": performOperation { $1 - $0 }
            case "✔️": performSingleOperation { sqrt($0) }
        default: break
        }
    }
    
    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            // Last two values operated on
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            // Add this value to stack
            enter()
        }
    }
    
    func performSingleOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    func multFunc(op1: Double, op2: Double) -> Double {
        return op1 * op2
    }
    
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        userBegin = true
        operandStack.append(displayValue)
        print("operandStack = \(operandStack)")
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userBegin = true
        }
    }

}

