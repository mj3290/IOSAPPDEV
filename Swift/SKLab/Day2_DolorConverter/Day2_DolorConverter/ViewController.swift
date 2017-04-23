//
//  ViewController.swift
//  Day2_DolorConverter
//
//  Created by Kim Dong-woo on 2017. 4. 13..
//  Copyright © 2017년 Kim Dong-woo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
  //  var selectIndex:Int = 0

    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var segButton: UISegmentedControl!
    
    @IBAction func segChanged(_ sender: Any) {
        //let control = sender as! UISegmentedControl
        //selectIndex = control.selectedSegmentIndex
    }
    
    @IBAction func didEndOnExit(_ sender: Any) {
    }
    
    // convert
    @IBAction func onConvert(_ sender: Any) {
        
        
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

