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
    
    var userBegin: Bool = true
    
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

}

