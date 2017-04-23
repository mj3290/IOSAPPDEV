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
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class MainViewController: UIViewController {//, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var authPolicyPicker: UIPickerView!
    
    let authPolicyMenus = ["앱 설정 (15세/1차)", "19세/2차", "19세/2차/CI", "19세/2차/CI/30일 이내"]
    var selectPolicyIndex:Int = 0
    
    var needToSignup = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        KOSessionTask.meTask { (result, error) -> Void in
            if error != nil {
                KOSessionTask.signupTask(withProperties: nil, completionHandler: { (success, error) -> Void in
                    if (error != nil) {
                        UIAlertView.showMessage("Signup 에 실패했습니다. 로그아웃 후 재로그인 해 보세요!")
                    } else {
                        UIAlertView.showMessage("Signup 에 성공했습니다!")
                    }
                })
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unlinkClicked(_ sender: AnyObject) {
        KOSessionTask.unlinkTask { (success, error) in
            if success {
                self.logout(sender);
            } else {
                UIAlertView.showMessage("\(error)");
            }
        }
    }
    
    @IBAction func ageAuthClicked(_ sender: AnyObject) {
        // -- [주의] --
        // 연령인증 웹뷰를 실행하기 전, 사용자의 연령인증정보를 요청하고 자신의 서비스 연령인증 기준에 맞춰 인증여부를 판단해야 한다.
        
        if selectPolicyIndex == 0 {
            // case 앱 설정 (15세/1차)
            
            // 인증정보 확인. KOAgeAuthLimitTypeNone을 넘겨주면 앱에 설정된 나이로 판별함.
            KOSessionTask.ageAuthTask(withCompletionHandler: .typeNone, propertyKeys: nil, completionHandler: { (result, error) in
                if error != nil {
                    UIAlertView.showMessage("\(error)")
                } else {
                    
                    // 샘플 앱에 설정된 인증레벨이 1차인증이므로 인증레벨 상관없이 연령통과가 참이면 인증 필요 없음.
                    if  let result = result as? [String: Any],
                        let bypassLimit = result[KOAgeAuthBypassLimitKey] as? Bool, bypassLimit == true {
                        UIAlertView.showMessage("이 사용자는 새로운 연령인증이 필요없는 상태입니다.")
                    } else {
                        
                        // 앱 설정 (15세/1차)로 연령인증 웹뷰 실행.
                        KOSession.shared().showAgeAuth(withAuthLevel: nil, completionHandler: { (success, error) in
                            if success {
                                UIAlertView.showMessage("연령인증에 성공했습니다.")
                            } else {
                                UIAlertView.showMessage("\(error)")
                            }
                        })
                    }
                }
            })
        
        } else if selectPolicyIndex == 1 {
            // case 19세/2차
            
            // 인증정보 확인. 19세 기준으로 인증정보를 요청함.
            let authLimit:KOAgeAuthLimit = .type19
            KOSessionTask.ageAuthTask(withCompletionHandler: authLimit, propertyKeys: nil, completionHandler: { (result, error) in
                if error != nil {
                    UIAlertView.showMessage("\(error)")
                } else {
                    
                    // 2차 인증을 필요로 하므로 인증레벨코드가 2 이상이고 연령통과가 참이면 패스.
                    if  let result = result as? [String: Any],
                        let levelCode = result[KOAgeAuthLevelCodeKey] as? Int, levelCode >= 2,
                        let bypassLimit = result[KOAgeAuthBypassLimitKey] as? Bool, bypassLimit == true {
                        UIAlertView.showMessage("이 사용자는 새로운 연령인증이 필요없는 상태입니다.")
                    } else {
                        
                        // 19세/2차로 연령인증 웹뷰 실행.
                        let ageAuthQueryStringBuilder = KOAgeAuthQueryStringBuilder()
                        ageAuthQueryStringBuilder.level = .type2
                        ageAuthQueryStringBuilder.limit = .type19
                        KOSession.shared().showAgeAuth(withAuthLevel: ageAuthQueryStringBuilder, completionHandler: { (success, error) in
                            if success {
                                UIAlertView.showMessage("연령인증에 성공했습니다.")
                            } else {
                                UIAlertView.showMessage("\(error)")
                            }
                        })
                    }
                }
            })
        
        } else if selectPolicyIndex == 2 {
            // case 19세/2차/CI
            
            // 인증정보 확인. 19세를 기준으로 CI를 포함한 인증정보 요청.
            let authLimit:KOAgeAuthLimit = .type19
            let propertyKeys:Set<NSNumber> = [NSNumber(value: KOAgeAuthProperty.accountCi.rawValue as Int)]
            KOSessionTask.ageAuthTask(withCompletionHandler: authLimit, propertyKeys: propertyKeys, completionHandler: { (result, error) in
                if error != nil {
                    UIAlertView.showMessage("\(error)")
                } else {
                    
                    // 인증레벨코드 2 이상, 연령통과, CI값 존재
                    if  let result = result as? [String: Any],
                        let levelCode = result[KOAgeAuthLevelCodeKey] as? Int, levelCode >= 2,
                        let bypassLimit = result[KOAgeAuthBypassLimitKey] as? Bool, bypassLimit == true,
                        let _ = result[KOAgeAuthCIKey] as? String {
                        UIAlertView.showMessage("이 사용자는 새로운 연령인증이 필요없는 상태입니다.")
                    } else {
                        
                        // 19세/2차로 연령인증 웹뷰 실행.
                        let ageAuthQueryStringBuilder = KOAgeAuthQueryStringBuilder()
                        ageAuthQueryStringBuilder.level = .type2
                        ageAuthQueryStringBuilder.limit = .type19
                        KOSession.shared().showAgeAuth(withAuthLevel: ageAuthQueryStringBuilder, completionHandler: { (success, error) in
                            if success {
                                UIAlertView.showMessage("연령인증에 성공했습니다.")
                            } else {
                                UIAlertView.showMessage("\(error)")
                            }
                        })
                    }
                }
            })
            
        } else {
            // case 19세/2차/CI/30일 이내
            
            // 인증정보 확인. 19세를 기준으로 CI를 포함한 인증정보 요청.
            let authLimit:KOAgeAuthLimit = .type19
            let propertyKeys:Set<NSNumber> = [NSNumber(value: KOAgeAuthProperty.accountCi.rawValue as Int)]
            KOSessionTask.ageAuthTask(withCompletionHandler: authLimit, propertyKeys: propertyKeys, completionHandler: { (result, error) in
                if error != nil {
                    UIAlertView.showMessage("\(error)")
                } else {
                    if let result = result as? [String: Any] {
                        
                        if let dateString = result[KOAgeAuthDateKey] as? String {
                            // 인증날짜 추출. RFC3339 internet date/time format
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                            let authDate = dateFormatter.date(from: dateString)
                            
                            let timeIntervalAuthThreshold = (authDate?.timeIntervalSinceNow)! + 30 * 24 * 60 * 60
                            let bypassLimit = result[KOAgeAuthBypassLimitKey] as? Bool
                            let levelCode = result[KOAgeAuthLevelCodeKey] as? Int
                            
                            // 인증레벨코드 2 이상, 연령통과, CI값 존재, 30일 이내
                            if levelCode >= 2, bypassLimit == true, let _ = result[KOAgeAuthCIKey] as? String, timeIntervalAuthThreshold >= 0  {
                                UIAlertView.showMessage("이 사용자는 새로운 연령인증이 필요없는 상태입니다.")
                            } else {
                                
                                // 19세/2차로 연령인증 웹뷰 실행.
                                let ageAuthQueryStringBuilder = KOAgeAuthQueryStringBuilder()
                                ageAuthQueryStringBuilder.level = .type2
                                ageAuthQueryStringBuilder.limit = .type19
                                KOSession.shared().showAgeAuth(withAuthLevel: ageAuthQueryStringBuilder, completionHandler: { (success, error) in
                                    if success {
                                        UIAlertView.showMessage("연령인증에 성공했습니다.")
                                    } else {
                                        UIAlertView.showMessage("\(error)")
                                    }
                                })
                            }
                        }
                    }
                }
            })
            
        }
    }
    
    @IBAction func logout(_ sender: AnyObject) {
        weak var weakSelf:MainViewController? = self
        
        KOSession.shared().logoutAndClose { (success, error) -> Void in
            _ = weakSelf?.navigationController?.popViewController(animated: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfComponentsInPickerView(_ pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return authPolicyMenus.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return authPolicyMenus[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectPolicyIndex = row
    }
    
}
