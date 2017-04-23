/**
* Copyright 2015-2016 Kakao Corp.
*
* Redistribution and modification in source or binary forms are not permitted without specific prior written permission.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*    http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import UIKit

class LoginViewController: UIViewController, UIAlertViewDelegate {
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        loginButton.setBackgroundColor(UIColor(red: 0xff / 255.0, green:  0xcc / 255.0, blue:  0x00 / 255.0, alpha: 1.0), forState: UIControlState())
        loginButton.setBackgroundColor(UIColor(red: 0xff / 255.0, green:  0xb4 / 255.0, blue:  0x00 / 255.0, alpha: 1.0), forState: UIControlState.highlighted)
        loginButton.clipsToBounds = true
        loginButton.layer.cornerRadius = 4
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(_ sender: AnyObject) {
        let session: KOSession = KOSession.shared();

        if session.isOpen() {
            session.close()
        }
        
        session.presentingViewController = self.navigationController
        session.open(completionHandler: { (error) -> Void in
            session.presentingViewController = nil
            
            if !session.isOpen() {
                switch ((error as! NSError).code) {
                case Int(KOErrorCancelled.rawValue):
                    break;
                default:
                    UIAlertView(title: "에러", message: error?.localizedDescription, delegate: nil, cancelButtonTitle: "확인").show()
                    break;
                }
            }
            }, authParams: nil, authTypes: [NSNumber(value: KOAuthType.talk.rawValue), NSNumber(value: KOAuthType.account.rawValue)])
    }
    
//    // MARK: - Navigation
//    
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//    // Get the new view controller using segue.destinationViewController.
//    // Pass the selected object to the new view controller.
//        
//        if segue.identifier == "login" {
//            let choiceViewController: LoginChoiceViewController = segue.destinationViewController as! LoginChoiceViewController
//            choiceViewController.authTypes = authenticationController.availableAuthType()
//        }
//    }
}

