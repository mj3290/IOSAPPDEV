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

class UserMgmtTableViewCell: UITableViewCell {
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var name: InsetableTextField!
    @IBOutlet weak var nickName: InsetableTextField!
    @IBOutlet weak var age: InsetableTextField!
    @IBOutlet weak var gender: InsetableTextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        name.inset = 10
        nickName.inset = 10
        age.inset = 10
        gender.inset = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUser(_ user: KOUser!) {
        self.thumbnail.image = UIImage(named: "PlaceHolder")
        
        if user == nil {
            return
        }
        
        var imageUrl: String! = nil
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
            imageUrl = user.properties["thumbnail_image"] as? String
        } else {
            imageUrl = user.properties["profile_image"] as? String
        }
        
        if let url = imageUrl, let thumbnailUrl = URL(string: url) {
            self.thumbnail.setImage(withUrl: thumbnailUrl)
        }

        
        if let name = user.properties["name"] as? String {
            self.name.text = name
        }
        
        if let nickName = user.properties["nickname"] as? String {
            self.nickName.text = nickName
        }
        
        if let age = user.properties["age"] as? String {
            self.age.text = age
        }
        
        if let gender = user.properties["gender"] as? String {
            self.gender.text = gender
        }
    }
    
    func getUser() -> [AnyHashable: Any] {
        var formData = [String:String]()
        
        formData["name"] = self.name.text
        formData["nickname"] = self.nickName.text
        formData["age"] = self.age.text
        formData["gender"] = self.gender.text
        
        return formData
    }    
}
