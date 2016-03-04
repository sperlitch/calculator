//
//  ViewController.swift
//  Calculator
//
//  Created by Scott Perlitch on 10/2/15.
//  Copyright © 2015 Scott Perlitch. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // CONTROLS THE DISPLAY
    
    
    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var history: UILabel!
    
    var userBegin = true
    
    var brain = CalculatorBrain() // MODEL
    
    
    @IBAction func backspace() {
        display.text = String(display.text!.characters.dropLast())
        if display.text!.characters.count < 1 {
            display.text = "0"
        }
    }
    
    
    
    @IBAction func getVariable(sender: UIButton) {
        let input = sender.currentTitle!
        if userBegin == false {
            enter()
        } else {
            let value = brain.getVariable(input)
            displayValue = value
            enter()
        }
    }
    
    @IBAction func setVariable() {
        brain.setVariable(displayValue!)
        enter()
        userBegin = true
    }
    
    
    @IBAction func appendDigit(sender: UIButton) {
        let input = sender.currentTitle!
        print("input = \(input)")
        if userBegin {
            display.text = input // set display
            userBegin = false
        } else {
            display.text = display.text! + input
        }
        
    }
    
    @IBAction func operate(sender: UIButton) {
        if userBegin == false {
            // 6 enter 3 enter X (enter)
            enter()
        }
        if let mathSymbol = sender.currentTitle {
            if let result = brain.performOperation(mathSymbol) {
                displayValue = result
                history.text = historyValue
            } else {
                // Error
                displayValue = 0
            }
        }
    }
    
    @IBAction func enter() { // Enter only happens after a number
        userBegin = true
        if displayValue == nil {
            display.text = "Error!"
            brain.clear()
        }
        else if let result = brain.pushNumber(displayValue!) {
            displayValue = result
            history.text = historyValue
        }
    }
    // Use display.text to get user input or set user input
    // Use displayValue to convert string to double
    
    @IBAction func clear() {
        displayValue = 0
        history.text = "[]"
        brain.clear()
    }
    
    var historyValue: String? {
        get {
            return brain.description
        }
        set (newValue) {
            
        }
    }
    
    var displayValue: Double? {
        
        get {
            // return double from string
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
        }
        set(newValue){
            display.text = "\(newValue!)"
            userBegin = true
        }
    }

}

