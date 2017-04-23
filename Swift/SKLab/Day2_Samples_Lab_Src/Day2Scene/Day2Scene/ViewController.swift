//
//  ViewController.swift
//  Day2Scene
//
//  Created by Jaehoon Lee on 2017. 4. 13..
//  Copyright © 2017년 vanillastep. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        let label = UILabel()
        label.frame = CGRect(x: 20, y: 20, width: 300, height: 60)
        label.text = "Hello iOS"
        label.textColor = UIColor.darkGray
        
        self.view.addSubview(label)
        
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 20, y: 200, width: 300, height: 300)
        view.addSubview(imageView)
        imageView.image = UIImage(named: "baseball")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
    }
    
    override func viewWillLayoutSubviews() {
        print("viewWillLayoutSubviews")
    }
    
    override func viewDidLayoutSubviews() {
        print("viewDidLayoutSubviews")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
    }
    
    

}

