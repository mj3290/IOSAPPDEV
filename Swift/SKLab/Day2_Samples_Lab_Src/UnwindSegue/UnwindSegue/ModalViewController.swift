//
//  ModalViewController.swift
//  UnwindSegue
//
//  Created by Jaehoon Lee on 2017. 4. 13..
//  Copyright © 2017년 vanillastep. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if "ModalDismissSegue" == segue.identifier {
            print(segue.destination)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
