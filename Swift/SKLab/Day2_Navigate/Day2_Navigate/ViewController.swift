//
//  ViewController.swift
//  Day2_Navigate
//
//  Created by Kim Dong-woo on 2017. 4. 13..
//  Copyright © 2017년 Kim Dong-woo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare")
        if segue.identifier == "DetailSegue"{
            
            let detail = segue.destination as! DetailViewController
            detail.data = "Hello"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

