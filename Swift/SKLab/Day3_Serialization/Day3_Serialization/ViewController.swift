//
//  ViewController.swift
//  Day3_Serialization
//
//  Created by Kim Dong-woo on 2017. 4. 14..
//  Copyright © 2017년 Kim Dong-woo. All rights reserved.
//

import UIKit

class MyClass : NSObject, NSCoding {
    var value:Int = 0
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(value, forKey: "Key")
    }
    
    required init?(coder aDecoder: NSCoder) {
        value = aDecoder.decodeInteger(forKey: "Key")
        
    }
    
    init(value :Int) {
        self.value = value
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let obj = MyClass(value: 3290)
        let data:Data = NSKeyedArchiver.archivedData(withRootObject: obj)
        
        let obj2  = NSKeyedUnarchiver.unarchiveObject(with: data) as! MyClass
        
        print("object : \(obj2.value)")
    }

    
}

