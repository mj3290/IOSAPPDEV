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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIDocumentInteractionControllerDelegate, UIAlertViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    fileprivate var menuItems: [String] = ["Send Link", "Send Link", "Share File", "Story Posting"]
    fileprivate var menuItemSubTexts: [String] = ["", "(UIActivityViewController)", "(UIDocumentInteractionController)", ""]
    
    fileprivate var documentController: UIDocumentInteractionController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        // Dispose of any resources that can be recreated.
    }
    
    func dummyLinkObject() -> [KakaoTalkLinkObject] {
        let label = KakaoTalkLinkObject.createLabel("Test Label\nNext Line")
        let image = KakaoTalkLinkObject.createImage("https://developers.kakao.com/assets/img/link_sample.jpg", width: 138, height: 80)
        let webLink = KakaoTalkLinkObject.createWebLink("Test Link", url: "http://www.kakao.com")
        
        let androidAppAction = KakaoTalkLinkAction.createAppAction(KakaoTalkLinkActionOSPlatform.android, devicetype: KakaoTalkLinkActionDeviceType.phone, execparam: ["test1" : "test1", "test2" : "test2"])
        let iphoneAppAction = KakaoTalkLinkAction.createAppAction(KakaoTalkLinkActionOSPlatform.IOS, devicetype: KakaoTalkLinkActionDeviceType.phone, execparam: ["test1" : "test1", "test2" : "test2"])
        let ipadAppAction = KakaoTalkLinkAction.createAppAction(KakaoTalkLinkActionOSPlatform.IOS, devicetype: KakaoTalkLinkActionDeviceType.pad, execparam: ["test1" : "test1", "test2" : "test2"])
        let appLink = KakaoTalkLinkObject.createAppButton("Test Button", actions: [androidAppAction!, iphoneAppAction!, ipadAppAction!])
        
        return [label!, image!, webLink!, appLink!]
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var normalCell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if normalCell == nil {
            normalCell = IconTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        }
        
        normalCell?.imageView?.image = UIImage(named: "LinkIcon\((indexPath as NSIndexPath).row)")
        normalCell?.textLabel?.text = menuItems[(indexPath as NSIndexPath).row]
        normalCell?.detailTextLabel?.text = menuItemSubTexts[(indexPath as NSIndexPath).row]
        
        return normalCell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch (indexPath as NSIndexPath).row {
        case 0:
            sendLink()
        case 1:
            showActivity()
        case 2:
            showChooseSharingFile()
        case 3:
            postStory()
        default:
            fatalError("no menu items.")
        }
    }
    
    func sendLink() {
        if KOAppCall.canOpenKakaoTalkAppLink() {
            KOAppCall.openKakaoTalkAppLink(dummyLinkObject())
        } else {
            print("Cannot open kakaotalk.")
        }
    }
    
    func showActivity() {
        let applicationActivity = KakaoLinkActivity(objects: dummyLinkObject())
        let storyPostingActivity = StoryPostingActivity(linkUrlString: dummyStoryLinkURLString())
        
        let activityViewController = UIActivityViewController(activityItems: [applicationActivity.ACTIVITY_NAME, storyPostingActivity.ACTIVITY_NAME],
            applicationActivities: [applicationActivity, storyPostingActivity])

        present(activityViewController, animated: true, completion: nil)
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            if #available(iOS 8.0, *) {
                activityViewController.popoverPresentationController!.permittedArrowDirections = UIPopoverArrowDirection.any
                activityViewController.popoverPresentationController!.sourceView = self.view;
                activityViewController.popoverPresentationController!.sourceRect = CGRect(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2, width: 0, height: 0);
            }
        }
    }
    
    func showChooseSharingFile() {
        UIAlertView(title: "", message: "공유 파일?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "JPG", "MP4", "TXT", "GIF").show()
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        switch buttonIndex {
        case 0:
            return // cancel
        case 1:
            shareFile(Bundle.main.url(forResource: "test_img", withExtension: "jpg"))
        case 2:
            shareFile(Bundle.main.url(forResource: "test_vod", withExtension: "mp4"))
        case 3:
            shareFile(Bundle.main.url(forResource: "test_text", withExtension: "txt")) // kakaotalk not support yet.
        case 4:
            shareFile(Bundle.main.url(forResource: "test_gif", withExtension: "gif")) // kakaotalk not support yet.
        default:
            fatalError("no item to share.")
        }
    }
    
    func shareFile(_ localPath: URL?) {
        if let localPath = localPath {
            documentController = UIDocumentInteractionController(url: localPath)
            documentController?.delegate = self
            documentController?.presentOptionsMenu(from: self.view.frame, in: self.view, animated: true)
        }
    }
    
    func documentInteractionControllerDidDismissOptionsMenu(_ controller: UIDocumentInteractionController) {
        self.documentController = nil
    }
    
    func dummyStoryLinkURLString() -> String! {
        let bundle = Bundle.main
        var scrapInfo = ScrapInfo()
        scrapInfo.title = "Sample"
        scrapInfo.desc = "Sample 입니다."
        scrapInfo.imageUrls = ["http://www.daumkakao.com/images/operating/temp_mov.jpg"]
        scrapInfo.type = ScrapType.Video
        
        if let bundleId = bundle.bundleIdentifier, let appVersion: String = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
            let appName: String = bundle.object(forInfoDictionaryKey: "CFBundleName") as? String {
                
            return StoryLinkHelper.makeStoryLink("Sample Story Posting https://www.youtube.com/watch?v=XUX1jtTKkKs",
                appBundleId: bundleId, appVersion: appVersion, appName: appName, scrapInfo: scrapInfo)
        }
        
        return nil;
    }
    
    func postStory() {
        if !StoryLinkHelper.canOpenStoryLink() {
            print("Cannot open kakao story.")
            return
        }
        
        if let urlString = dummyStoryLinkURLString() {
            _ = StoryLinkHelper.openStoryLink(urlString)
        }
    }
}

