//
//  ViewController.swift
//  Day3_UserDefault
//
//  Created by Kim Dong-woo on 2017. 4. 14..
//  Copyright © 2017년 Kim Dong-woo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var mySwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let setting = UserDefaults.standard
        
        setting.setValue(1, forKey:"prenotify")
        
        let date = Date()
        setting.setValue(date, forKey: "date")
        
        setting.synchronize()
        
        print(NSHomeDirectory())
        
    }

    @IBAction func save(_ sender: Any) {
        
        let setting = UserDefaults.standard
        
        setting.set(mySwitch.isOn, forKey:"prenotify")
        setting.setValue(datePicker.date, forKey: "date")
        
        setting.synchronize()
        
    }
    
        
    @IBAction func restore(_ sender: Any) {
        let setting = UserDefaults.standard

        let date = setting.object(forKey: "date")
        
        datePicker.setDate(date as! Date, animated: true)
        
        let prenotifyflag = setting.bool(forKey: "prenotify")
        
        mySwitch.setOn(prenotifyflag, animated: true)
    }
   
}

