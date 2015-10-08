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
    
    var brain = CalculatorBrain() // MODEL
    
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
        if userBegin == false {
            enter()
        }
        // Figure out who is sending
        if let mathSymbol = sender.currentTitle {
            if let result = brain.performOperation(mathSymbol) {
                displayValue = result
            } else {
                // Error
                displayValue = 0
            }
        }
    }
    
    @IBAction func enter() { // Enter only happens after a number
        userBegin = true
        if let result = brain.pushNumber(displayValue) {
            displayValue = result
        } else {
            // Error nil optional? error message in calculator
            displayValue = 0
        }
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

