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

class ChatMessageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var chatContext: KOChatContext!
    var chatList: NSMutableArray = []
    var filteredChatList: NSMutableArray = []
    
    var requesting: Bool = false
    var selectedChat: KOChat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.tableHeaderView = searchBar;
        
        searchBar.delegate = self;
        searchDisplayController!.searchResultsTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // it will be deprecated in the near future.
        // chatContext = KOChatContext(chatType: .Group, limit: 30, ordering: .Ascending)
        
        chatContext = KOChatContext(chatFilters: KOChatFilters(), limit: 30, ordering: .ascending)
        requestChatList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requestChatList() {
        if chatContext == nil {
            print("chatContext must be setup.")
            return
        }
        
        if requesting || !chatContext.hasMoreItems {
            return
        }
        
        requesting = true
        KOSessionTask.talkChatListTask(with: chatContext, completionHandler: { [weak self] (chats, error) -> Void in
            if error == nil {
                if let totalCount = self?.chatContext.totalCount {
                    self?.title = "Chat (\(totalCount))"
                }
                self?.chatList.addObjects(from: chats!)
                self?.tableView.reloadData()
            } else {
                print("Chats error=\(error)")
                if let error: NSError = error as NSError? , error.code == Int(KOErrorCancelled.rawValue) {
                    _ = self?.navigationController?.popViewController(animated: true)
                }
            }
            self?.requesting = false
            })
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == alertView.cancelButtonIndex {
            return
        }
        
        sendTemplateMessage()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == searchDisplayController!.searchResultsTableView {
            return filteredChatList.count
        }
        return chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var normalCell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if normalCell == nil {
            normalCell = ThumbnailImageViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        }
        
        let chats = (tableView == searchDisplayController!.searchResultsTableView ? filteredChatList : chatList);
        let chat: KOChat = (chats[(indexPath as NSIndexPath).row] as? KOChat)!
        
        normalCell?.textLabel?.text = chat.title
        normalCell?.detailTextLabel?.text = "Members : \(chat.memberCount)"
        normalCell?.imageView?.image = UIImage(named: "PlaceHolder")
        if let url = chat.thumbnailURL, let imageUrl = URL(string: url) , !imageUrl.absoluteString.isEmpty {
            normalCell?.imageView?.setImage(withUrl: imageUrl)
        }
        
        // load more
        if tableView == self.tableView {
            let count = chats.count
            if (indexPath as NSIndexPath).row > (count - count / 3) {
                requestChatList()
            }
        }
        
        return normalCell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let chats = (tableView == searchDisplayController!.searchResultsTableView ? filteredChatList : chatList);
        selectedChat = chats[(indexPath as NSIndexPath).row] as! KOChat
        
        let alert = UIAlertView(title: "Send Message?", message: "", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
        alert.show()
    }
    
    func sendTemplateMessage() {
        if selectedChat == nil {
            return
        }
        
        let chat: KOChat = selectedChat!
        selectedChat = nil
        
        let templateID = "10"  // feed template message id
        chat.sendMessage(withTemplateID: templateID, arguments: ["msg":"새로운 연결, 새로운 세상.", "iphoneMarketParam":"test", "iphoneExecParam":"test"]) { (error) -> Void in
            if let error = error as? NSError {
                if error.code != Int(KOErrorOperationInProgress.rawValue) {
                    UIAlertView.showMessage("message send failed:\(error)")
                }
            } else {
                UIAlertView.showMessage("message send succeed.")
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredChatList.removeAllObjects();
        
        if !searchText.isEmpty {
            for chat in chatList {
                if let title: String = (chat as AnyObject).title , title.range(of: searchText, options: NSString.CompareOptions.caseInsensitive, range: nil, locale: nil) != nil {
                    filteredChatList.add(chat);
                }
            }
        }
        
        tableView.reloadData()
    }
}
