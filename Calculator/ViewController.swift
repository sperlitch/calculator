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
        let operation = sender.currentTitle!
        
        // If u
        if userBegin == false {
            enter()
        }
        switch operation {
            case "✖️":
                if operandStack.count >= 2 {
                    // Last two values operated on
                    displayValue = operandStack.removeLast() * operandStack.removeLast()
                    // Add this value to stack
                    enter()
                }
//            case "➗":
//            case "➕":
//            case "➖":
        default: break
        }
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

