//
//  ViewController.swift
//  Day3_SandBox
//
//  Created by Kim Dong-woo on 2017. 4. 14..
//  Copyright © 2017년 Kim Dong-woo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let plistFileName  = Bundle.main.path(forResource: "data", ofType: "plist")!
        let array = NSArray(contentsOfFile: plistFileName)!
        print(array)
        print("first \(array[0])")
    }
}

