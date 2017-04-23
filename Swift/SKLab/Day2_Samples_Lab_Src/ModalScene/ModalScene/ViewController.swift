//
//  ViewController.swift
//  ModalScene
//
//  Created by Jaehoon Lee on 2017. 4. 13..
//  Copyright © 2017년 vanillastep. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ModalDelegate {
    
    var data: String!
    
    @IBAction func dismissModal(segue: UIStoryboardSegue) {
        
    }
    
    func modalActionDone(data: String) {
        print("Action Done with Delegate : \(data)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let modalVC = segue.destination as! ModalViewController
        modalVC.delegate = self
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

