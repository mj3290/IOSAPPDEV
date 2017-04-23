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

class StoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    fileprivate var storyProfile: KOStoryProfile!
    fileprivate var lastStoryId: String? = nil
    fileprivate var menu: [String]? = nil
    fileprivate var isStoryUser: Bool = false
    fileprivate var popoverController: UIPopoverController?
    fileprivate var singleTapGesture: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(StoryViewController.profileImageTapped(_:)))
        singleTapGesture.numberOfTapsRequired = 1
        singleTapGesture.numberOfTouchesRequired = 1

        tableView.delegate = self;
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        let nib = UINib(nibName: "StoryProfileTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "StoryProfileTableViewCell")
        
        KOSessionTask.storyIsStoryUserTask { [weak self] (isStoryUser, error) -> Void in
            if error == nil {
                let isUser: String = String(stringInterpolationSegment: isStoryUser)
                print("isStoryUser success = \(isUser)")
                self?.isStoryUser = isStoryUser
                
                if isStoryUser == true {
                    self?.loadStoryMenu()
                } else {
                    UIAlertView.showMessage("스토리 유저가 아닙니다.")
                }
            } else {
                print("isStoryUser failed = \(error)")
            }
        }
    }

    func loadStoryMenu() {
        KOSessionTask.storyProfileTask { [weak self] (profile, error) -> Void in
            if profile != nil {
                print("\(profile)")
                self?.storyProfile = profile as? KOStoryProfile
                self?.menu = ["Post Note", "Post Photo", "Post Link", "Get My Story", "Get My Stories", "Delete Last Story"]
                self?.tableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return (isStoryUser ? 2 : 1)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if ((indexPath as NSIndexPath).section == 0 && isStoryUser == true) {
            return 213
        }
        return 48
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isStoryUser == false {
            return 0
        }
        
        if section == 0 {
            return 1
        }
        return (menu == nil ? 0 : menu!.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).section == 0 {
            let cell: StoryProfileTableViewCell = tableView.dequeueReusableCell(withIdentifier: "StoryProfileTableViewCell") as! StoryProfileTableViewCell
            cell.setStoryProfile(self.storyProfile)
            
            var addGesture = true
            if let gestures: [AnyObject] = cell.profileImageView.gestureRecognizers {
                addGesture = gestures.filter {$0 as? UIGestureRecognizer == self.singleTapGesture}.isEmpty
            }
            
            if addGesture {
                cell.profileImageView.addGestureRecognizer(singleTapGesture)
                cell.profileImageView.isUserInteractionEnabled = true
            }
            
            return cell
        }
        
        var normalCell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if normalCell == nil {
            normalCell = IconTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        }
        
        if let menu = self.menu {
            normalCell?.imageView?.image = UIImage(named: "StoryMenuIcon\((indexPath as NSIndexPath).row)")
            normalCell?.textLabel?.text = menu[(indexPath as NSIndexPath).row]
        }
        
        return normalCell!
    }

    func profileImageTapped(_ recognizer: UITapGestureRecognizer) {
        if (storyProfile == nil || storyProfile.profileImageURL == nil || storyProfile.profileImageURL.isEmpty) {
            return
        }
        
        self.performSegue(withIdentifier: "ProfileImage", sender: storyProfile.profileImageURL)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = self.menu , (indexPath as NSIndexPath).section == 1 {
            let menuString: String = menu[(indexPath as NSIndexPath).row]

            switch menuString {
            case "Post Note":
                postNote()
            case "Post Photo":
                postPhoto()
            case "Post Link":
                postLink()
            case "Get My Story":
                getMyStory()
            case "Get My Stories":
                getMyStories()
            case "Delete Last Story":
                deleteLastStory()
            default:
                fatalError("no menu item!!")
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func postNote() {
        KOSessionTask.storyPostNote(withContent: "post note test",
            permission: KOStoryPostPermission.friend,
            sharable: true,
            androidExecParam: ["andParam1" : "value1", "andParam2" : "value2"],
            iosExecParam: ["iosParam1" : "value1", "iosParam2" : "value2"]) { [weak self] (result, error) -> Void in
                
                if let strongSelf = self {
                    if error != nil {
                        UIAlertView.showMessage("post note failed = \(error)")
                    } else {
                        strongSelf.lastStoryId = result?.id;
                        UIAlertView.showMessage("post note success = \(result?.id)")
                        
                    }
                }
        }
    }
    
    func postPhoto() {
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
        picker.allowsEditing = true
        picker.delegate = self
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            self.popoverController = UIPopoverController(contentViewController: picker)
            self.popoverController?.present(from: CGRect(x: 0, y: 0, width: 400, height: 400), in: self.view, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
        } else {
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    func storyPostImages(_ imageUrls: [String]) {
        KOSessionTask.storyPostPhotoTask(withImageUrls: imageUrls,
            content: "post photo test",
            permission: KOStoryPostPermission.friend,
            sharable: true,
            androidExecParam: ["andParam1" : "value1", "andParam2" : "value2"],
            iosExecParam: ["iosParam1" : "value1", "iosParam2" : "value2"]) { [weak self] (result, error) -> Void in
                
                if let strongSelf = self {
                    if error != nil {
                        UIAlertView.showMessage("post photo failed = \(error)")
                    } else {
                        strongSelf.lastStoryId = result?.id;
                        UIAlertView.showMessage("post photo success = \(result?.id)")
                        
                    }
                }
        }
    }
    
    func postLink() {
        KOSessionTask.storyGetLinkInfoTask(withUrl: "https://developers.kakao.com", completionHandler: { [weak self] (result, error) -> Void in
            if let strongSelf = self {
                if error != nil {
                    UIAlertView.showMessage("get link info failed = \(error)")
                } else {
                    strongSelf.storyPostLink(result!)
                }
            }
        })
    }
    
    func storyPostLink(_ linkInfo: KOStoryLinkInfo) {
        KOSessionTask.storyPostLinkTask(with: linkInfo,
            content: "post link test",
            permission: KOStoryPostPermission.friend, sharable: true,
            androidExecParam: ["andParam1" : "value1", "andParam2" : "value2"],
            iosExecParam: ["iosParam1" : "value1", "iosParam2" : "value2"]) { [weak self] (result, error) -> Void in
                
                if let strongSelf = self {
                    if error != nil {
                        UIAlertView.showMessage("post link failed = \(error)")
                    } else {
                        strongSelf.lastStoryId = result?.id;
                        UIAlertView.showMessage("post link success = \(result)")
                        
                    }
                }
        }
    }
    
    func getMyStory() {
        if let postId = self.lastStoryId {
            KOSessionTask.storyGetMyStoryTask(withMyStoryId: postId, completionHandler: { (storyInfo, error) -> Void in
                if error == nil {
                    UIAlertView.showMessage("my story success = \(storyInfo)")
                } else {
                    UIAlertView.showMessage("my story failed = \(error)")
                }
            })
        } else {
            UIAlertView.showMessage("포스팅을 먼저 해주세요!")
        }
    }
    
    func getMyStories() {
        if let postId = self.lastStoryId {
            KOSessionTask.storyGetMyStoriesTask(withLastMyStoryId: postId, completionHandler: { (result, error) -> Void in
                if error == nil {
                    UIAlertView.showMessage("my stories success = \(result)")
                } else {
                    UIAlertView.showMessage("my stories failed = \(error)")
                }
            })
        } else {
            UIAlertView.showMessage("포스팅을 먼저 해주세요!")
        }
    }
    
    func deleteLastStory() {
        if let postId = self.lastStoryId {
            KOSessionTask.storyDeleteMyStoryTask(withMyStoryId: postId, completionHandler: { [weak self] (error) -> Void in
                if error == nil {
                    self?.lastStoryId = nil
                    UIAlertView.showMessage("delete success.")
                } else {
                    UIAlertView.showMessage("delete failed = \(error)")
                }
            })
        } else {
            UIAlertView.showMessage("포스팅을 먼저 해주세요!")
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileImage" {
            let viewController: ProfileImageViewController = (segue.destination as? ProfileImageViewController)!
            viewController.profileImageUrlString = sender as? String
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismissImagePickerViewController()
        
        var image: UIImage? = info[UIImagePickerControllerEditedImage] as? UIImage
        if image == nil {
            image = info[UIImagePickerControllerOriginalImage] as? UIImage
            
            if image == nil {
                return;
            }
        }
        
        KOSessionTask.storyMultiImagesUploadTask(withImages: [image!], completionHandler: { [weak self] (imageUrls, error) -> Void in
            if let strongSelf = self {
                if error != nil {
                    UIAlertView.showMessage("upload photo failed. \(error)")
                } else {
                    strongSelf.storyPostImages(imageUrls!)
                }
            }
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismissImagePickerViewController()
    }
    
    fileprivate func dismissImagePickerViewController() {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            self.popoverController?.dismiss(animated: true)
            self.popoverController = nil
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
