//
//  ViewController.swift
//  Calculator
//
//  Created by Kim Dong-woo on 2017. 3. 1..
//  Copyright © 2017년 Kim Dong-woo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfString = false;
  
    @IBAction func touchedNumber(_ sender: UIButton) {
        
        let digit = sender.currentTitle!
        if( userIsInTheMiddleOfString){
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit;
        }
        else{
            display.text = digit
        }
        userIsInTheMiddleOfString = true

    }
    
    var dispayValue : Double {
        
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
}

