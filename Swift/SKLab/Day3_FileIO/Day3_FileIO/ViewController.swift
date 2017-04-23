//
//  ViewController.swift
//  Day3_FileIO
//
//  Created by Kim Dong-woo on 2017. 4. 14..
//  Copyright © 2017년 Kim Dong-woo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print( "Bundle : \(Bundle.main.bundlePath)")
        print( "Home : \(NSHomeDirectory())")
        
        
        let str = "Hello IOS"
        let filePath  = NSHomeDirectory() + "/Documents/str.txt"
        do {
            try str.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
            //ry str.write(toFile: filePath, atomically : true, encording: uft8)
        }catch let error {
            print("Error : \(error.localizedDescription)")
        }
        
        let newStr = try? String(contentsOfFile: filePath, encoding: String.Encoding.utf8)
        print("string from file : \(String(describing: newStr))")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

