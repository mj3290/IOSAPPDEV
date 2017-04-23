//
//  ViewController.swift
//  ControlValue
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func segmentChanged(_ sender: Any) {
        let control = sender as! UISegmentedControl
        print(control.selectedSegmentIndex)
    }
    
    @IBOutlet weak var textField: UITextField!
    @IBAction func dismissKeyboard(_ sender: Any) {
        textField.resignFirstResponder()
    }
    // Did End On Exit
    @IBAction func didEndOnExit(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

