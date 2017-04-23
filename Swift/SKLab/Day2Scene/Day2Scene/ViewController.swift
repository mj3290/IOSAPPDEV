//
//  ViewController.swift
//  Day2Scene
//
//  Created by Kim Dong-woo on 2017. 4. 13..
//  Copyright © 2017년 Kim Dong-woo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label1: UILabel!
    
   
    @IBAction func touchup(_ sender: Any) {
        
        //let btn = UIButton(_ sender)
        
        
        label1.text = "touched"
        label1.textColor = UIColor.red
    }
}

