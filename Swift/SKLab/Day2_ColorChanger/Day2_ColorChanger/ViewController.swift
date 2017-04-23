//
//  ViewController.swift
//  Day2_ColorChanger
//
//  Created by Kim Dong-woo on 2017. 4. 13..
//  Copyright © 2017년 Kim Dong-woo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var uiview: UIView!
    @IBOutlet weak var colorChange: UIButton!
    
    @IBAction func handleClick(_ sender: Any) {
        label.text = "Hello"
        label.textColor = UIColor.red

    }
    
    var colorArr:[UIColor] = []
    
    @IBAction func colorChanged(_ sender: Any) {
        let arrCnt:Int32 = Int32(colorArr.count-1)
        let index:Int = Int(arc4random_uniform(UInt32(arrCnt)))
        
        uiview.backgroundColor = colorArr[index]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorArr.append(UIColor.red)
        colorArr.append(UIColor.blue)
        colorArr.append(UIColor.green)
        colorArr.append(UIColor.cyan)
        
        
    }

    


}

