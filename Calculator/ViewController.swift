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
            display.text = input
            userBegin = false
        } else {
            display.text = display.text! + input
        }
        
    }
    
    @IBAction func operate(sender: UIButton) {
        if userBegin == false {
            enter()
        }
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
        if displayValue == nil {
            display.text = "Error!"
            brain.clear()
        }
        else if let result = brain.pushNumber(displayValue!) {
            displayValue = result
        }
    }
    
    
    @IBAction func clear() {
        displayValue = 0
        brain.clear()
    }
    
    var displayValue: Double? {
        
        get {
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
        }
        set {
            display.text = "\(newValue!)"
            userBegin = true
        }
    }

}

