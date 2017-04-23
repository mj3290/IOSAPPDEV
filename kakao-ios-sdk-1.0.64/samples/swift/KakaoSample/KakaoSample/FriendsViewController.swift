/**
* Copyright 2015 Kakao Corp.
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
class FriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    enum OptionType: Int {
        case talkAll = 1
        case talkRegistered
        case talkInvitable
        case talkAndStoryAll
        case talkAndStoryRegistered
        case talkAndStoryInvitable
        
        static func toType(_ type: Int) -> OptionType {
            switch type {
            case talkRegistered.rawValue:
                return talkRegistered
            case talkInvitable.rawValue:
                return talkInvitable
            case talkAndStoryAll.rawValue:
                return talkAndStoryAll
            case talkAndStoryRegistered.rawValue:
                return talkAndStoryRegistered
            case talkAndStoryInvitable.rawValue:
                return talkAndStoryInvitable
            default:
                break
            }
            
            return talkAll
        }
    }
    
    let limitCount: Int = 2000
    
    var friendContext: KOFriendContext!
    var allFriends: NSMutableArray = []
    var filteredFriends: NSMutableArray = []
    
    var requesting: Bool = false
    var optionType: OptionType = .talkAll
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.tableHeaderView = searchBar;
        
        searchBar.delegate = self;
        searchDisplayController!.searchResultsTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        setupFriendContext()
        requestTalkFriends()
    }
    
    func setupFriendContext() {
        switch optionType {
        case .talkRegistered:
            friendContext = KOFriendContext(serviceType: .talk, filterType: .registered, limit: limitCount)
        case .talkInvitable:
            friendContext = KOFriendContext(serviceType: .talk, filterType: .invitableNotRegistered, limit: limitCount)
        case .talkAndStoryAll:
            friendContext = KOFriendContext(serviceType: .talkAndStory, filterType: .all, limit: limitCount)
        case .talkAndStoryRegistered:
            friendContext = KOFriendContext(serviceType: .talkAndStory, filterType: .registered, limit: limitCount)
        case .talkAndStoryInvitable:
            friendContext = KOFriendContext(serviceType: .talkAndStory, filterType: .invitableNotRegistered, limit: limitCount)
        default:
            friendContext = KOFriendContext(serviceType: .talk, filterType: .all, limit: limitCount)
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
                print("friends error=\(error)")
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
        UIAlertView(title: "", message: "Options?", delegate: self, cancelButtonTitle: "Cancel",
            otherButtonTitles: "Talk (All)", "Talk (Registered)", "Talk (Invitable)", "TalkAndStory (All)", "TalkAndStory (Registered)", "TalkAndStory (Invitable)").show()
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == alertView.cancelButtonIndex {
            return
        }
        
        let type = OptionType.toType(buttonIndex)
        if type == optionType {
            return
        }
        
        optionType = type
        self.allFriends.removeAllObjects()
        self.tableView.reloadData()
        
        setupFriendContext()
        requestTalkFriends()
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
        
        let friends = (tableView == searchDisplayController!.searchResultsTableView ? filteredFriends : allFriends);
        let friend: KOFriend = (friends[(indexPath as NSIndexPath).row] as? KOFriend)!
        normalCell?.textLabel?.text = friend.nickName
        
        normalCell?.imageView?.image = UIImage(named: "PlaceHolder")
        if let url = friend.thumbnailURL, let imageUrl = URL(string: url) , !imageUrl.absoluteString.isEmpty {
            normalCell?.imageView?.setImage(withUrl: imageUrl)
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
        showAlert(friends[(indexPath as NSIndexPath).row] as! KOFriend)
    }
    
    func showAlert(_ friend: KOFriend!) {
        if friend == nil {
            return
        }
        
        if let friend = friend {
            var message: String = "id:\(friend.id)\nuuid:\(friend.uuid)\nappRegistered:\(friend.isAppRegistered)"
            message += "\nnickname:\(friend.nickName)"
            message += "\nos:\(convertOSPropertyTypeString(friend.talkOS))"
            message += "\nallowedTalkMessaging:\(friend.isAllowedTalkMessaging)"
            message += "\nrelations:"
            if friend.talkRelation == .friend {
                message += " talk"
            }
            if friend.storyRelation == .friend {
                message += " story"
            }
            
            UIAlertView.showMessage(message)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredFriends.removeAllObjects();
        
        if searchText.isEmpty {
        } else {
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
