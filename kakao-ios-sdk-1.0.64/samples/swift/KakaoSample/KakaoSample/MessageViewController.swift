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

class MessageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    enum OptionType: Int {
        case talkInvitable = 1
        case talkRegistered
        
        static func toType(_ type: Int) -> OptionType {
            switch type {
            case talkRegistered.rawValue:
                return talkRegistered
            default:
                break
            }
            
            return talkInvitable
        }
    }
    
    let limitCount: Int = 2000
    
    var friendContext: KOFriendContext!
    var allFriends: NSMutableArray = []
    var filteredFriends: NSMutableArray = []
    
    var requesting: Bool = false
    var optionType: OptionType = .talkInvitable
    var selectedFriend: AnyObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.tableHeaderView = searchBar;
        
        searchBar.delegate = self;
        searchDisplayController!.searchResultsTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // 일단 내 정보를 먼저 가져온다.
        requestMe()

    }
    
    func requestMe(_ displayResult: Bool = false) {
        KOSessionTask.meTask { [weak self] (user, error) -> Void in
            if error != nil {
                print("requestMe error=\(error)")
                if let error:NSError = error as NSError? , error.code == Int(KOErrorCancelled.rawValue) {
                    _ = self?.navigationController?.popViewController(animated: true)
                }
            } else {
                self?.allFriends.add((user as? KOUser)!)
                
                // Talk 친구 정보를 가져온다.
                self?.setupFriendContext()
                self?.requestTalkFriends()
            }
        }
    }
    
    func setupFriendContext() {
        switch optionType {
        case .talkRegistered:
            friendContext = KOFriendContext(serviceType: .talk, filterType: .registered, limit: limitCount)
        default:
            friendContext = KOFriendContext(serviceType: .talk, filterType: .invitableNotRegistered, limit: limitCount)
        }
    }
    
    func requestTalkFriends() {
        if friendContext == nil {
            print("friendContext must be setup.")
            return
        }
        
        if requesting || !friendContext.hasMoreItems {
            return
        }
        
        requesting = true
        KOSessionTask.friends(with: friendContext, completionHandler: { [weak self] (friends, error) -> Void in
            if error == nil {
                if let totalCount = self?.friendContext.totalCount {
                    self?.title = "Friends (\(totalCount))"
                }
                self?.allFriends.addObjects(from: friends!)
                self?.tableView.reloadData()
            } else {
                print("allFriends error=\(error)")
                if let error: NSError = error as NSError? , error.code == Int(KOErrorCancelled.rawValue) {
                    _ = self?.navigationController?.popViewController(animated: true)
                }
            }
            self?.requesting = false
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectOptions(_ sender: AnyObject) {
        let alert = UIAlertView(title: "Options?", message: "", delegate: self, cancelButtonTitle: "Cancel",
            otherButtonTitles: "Invitable, Not App Registered", "App Registered")
        alert.tag = 1
        alert.show()
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == alertView.cancelButtonIndex {
            return
        }
        
        switch alertView.tag {
        case 1:
            let type = OptionType.toType(buttonIndex)
            if type == optionType {
                return
            }
            
            optionType = type
            self.allFriends.removeAllObjects()
            self.tableView.reloadData()
            
            setupFriendContext()
            requestTalkFriends()
            
        case 2:
            sendTemplateMessage()
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == searchDisplayController!.searchResultsTableView {
            return filteredFriends.count
        }
        return allFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var normalCell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if normalCell == nil {
            normalCell = ThumbnailImageViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        }
        
        let isSearchedResult = tableView == searchDisplayController!.searchResultsTableView
        let friends = (isSearchedResult ? filteredFriends : allFriends);
        let friend: AnyObject = friends[(indexPath as NSIndexPath).row] as AnyObject
        
        if friend is KOUser {
            let user = friend as! KOUser
            
            normalCell?.textLabel?.text = "ToMe(나에게)"
            normalCell?.imageView?.image = UIImage(named: "PlaceHolder")
            if let url = user.properties["thumbnail_image"], let imageUrl = URL(string: url as! String) , !imageUrl.absoluteString.isEmpty {
                normalCell?.imageView?.setImage(withUrl: imageUrl)
            }
        } else {
            normalCell?.textLabel?.text = friend.nickName
            normalCell?.imageView?.image = UIImage(named: "PlaceHolder")
            if let url = friend.thumbnailURL, let imageUrl = URL(string: url) , !imageUrl.absoluteString.isEmpty {
                normalCell?.imageView?.setImage(withUrl: imageUrl)
            }
        }
    
        // load more
        if tableView == self.tableView {
            let friendsCount = friends.count
            if (indexPath as NSIndexPath).row > (friendsCount - friendsCount / 3) {
                requestTalkFriends()
            }
        }
        
        return normalCell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let friends = (tableView == searchDisplayController!.searchResultsTableView ? filteredFriends : allFriends);
        selectedFriend = friends[(indexPath as NSIndexPath).row] as AnyObject!
        
        let alert = UIAlertView(title: "Send Message?", message: "", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
        alert.tag = 2
        alert.show()
    }
    
    func sendTemplateMessage() {
        if selectedFriend == nil {
            return
        }
        
        if selectedFriend is KOUser {
            let user:KOUser = (selectedFriend as? KOUser)!
            user.sendMemo(withTemplateID: MessageViewControllerConstants.templateID, messageArguments: ["MESSAGE":"안녕하세요? 나와의 채팅방으로 보낸 메세지입니다.", "DATE":"지금은 2016-XX-XX 입니다."], completionHandler: { (error) -> Void in
                if let error: NSError = error as? NSError {
                    if error.code != Int(KOErrorOperationInProgress.rawValue) {
                        UIAlertView.showMessage("message send failed:\(error)")
                    }
                } else {
                    UIAlertView.showMessage("message send succeed.")
                }
            })
        } else {
            let friend: KOFriend = selectedFriend as! KOFriend
            selectedFriend = nil
            
            if friend.isAllowedTalkMessaging == false {
                UIAlertView.showMessage("friend set message blocked.")
                return;
            }
            
            if optionType == .talkInvitable {
                let templateID = "9"  // invite template message id
                friend.sendMessage(withTemplateID: templateID, arguments: ["name":friend.nickName, "iphoneMarketParam":"test", "iphoneExecParam":"test"], completionHandler: { (error) -> Void in
                    if let error: NSError = error as? NSError {
                        if error.code != Int(KOErrorOperationInProgress.rawValue) {
                            UIAlertView.showMessage("message send failed:\(error)")
                        }
                    } else {
                        UIAlertView.showMessage("message send succeed.")
                    }
                })
            } else {
                let templateID = "10"  // feed template message id
                friend.sendMessage(withTemplateID: templateID, arguments: ["msg":"새로운 연결, 새로운 세상.", "iphoneMarketParam":"test", "iphoneExecParam":"test"], completionHandler: { (error) -> Void in
                    if let error: NSError = error as? NSError {
                        if error.code != Int(KOErrorOperationInProgress.rawValue) {
                            UIAlertView.showMessage("message send failed:\(error)")
                        }
                    } else {
                        UIAlertView.showMessage("message send succeed.")
                    }
                })
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredFriends.removeAllObjects();
        
        if !searchText.isEmpty {
            for friend in allFriends {
                if let nickName = (friend as AnyObject).nickName , nickName.range(of: searchText, options: NSString.CompareOptions.caseInsensitive, range: nil, locale: nil) != nil {
                    filteredFriends.add(friend);
                }
            }
        }
        
        tableView.reloadData()
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
