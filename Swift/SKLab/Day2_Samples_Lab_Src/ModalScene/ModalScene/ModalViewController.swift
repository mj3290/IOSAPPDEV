//
//  ModalViewController.swift
//  ModalScene
//
//  Created by Jaehoon Lee on 2017. 4. 13..
//  Copyright © 2017년 vanillastep. All rights reserved.
//

import UIKit

protocol ModalDelegate {
    func modalActionDone(data: String)
}

class ModalViewController: UIViewController {
    @IBAction func closeModal(_ sender: Any) {
        let vc = self.presentingViewController as! ViewController
        vc.data = "Modal Data with PresentingVC Relation"
        self.dismiss(animated: true, completion: nil)
    }
    
    var delegate: ModalDelegate!
    
    @IBAction func closeModalWithDelegate() {
        if delegate != nil {
            delegate.modalActionDone(data:"Modal Data")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ViewController
        vc.data = "Hello"
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
