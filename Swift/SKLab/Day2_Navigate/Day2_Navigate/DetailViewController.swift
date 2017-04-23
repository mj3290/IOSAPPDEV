//
//  DetailViewController.swift
//  Day2_Navigate
//
//  Created by Kim Dong-woo on 2017. 4. 13..
//  Copyright © 2017년 Kim Dong-woo. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var data:String!
    

    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        label.text = data
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
