//
//  ViewController.swift
//  Day2_ColorChanger
//

import UIKit

class ViewController: UIViewController {
    
    func buttonClicked(sender: UIButton) {
        colorView.backgroundColor = UIColor.red
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorView = UIView()
        colorView.frame = CGRect(x: 0, y: 200,
                                 width: self.view.frame.size.width, height: 300)
        self.view.addSubview(colorView)
        colorView.backgroundColor = UIColor.lightGray
        
        let button = UIButton()
        button.frame = CGRect(x: 50, y: 50, width: 100, height: 60)
        self.view.addSubview(button)
        
        button.setTitle("RED", for: UIControlState.normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        
        button.addTarget(self,
                         action: #selector(buttonClicked(sender:)), for: .touchUpInside)
        
    }

}

