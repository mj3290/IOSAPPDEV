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

class StorageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var originalImageView: UIImageView!
    var popoverController: UIPopoverController!
    
    @IBAction func upload(_ sender: AnyObject) {
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismissImagePickerViewController()
        
        var image: UIImage? = info[UIImagePickerControllerEditedImage] as? UIImage
        if image == nil {
            image = info[UIImagePickerControllerOriginalImage] as? UIImage
            
            if image == nil {
                return;
            }
        }
        
        KOSessionTask.storageImageUploadTask(with: image, secureResource: false) { [weak self] (imageInfo, error) -> Void in
            if error != nil {
                UIAlertView.showMessage("upload image failed. \(error)")
            } else {
                if let thumbnailImageURL = URL(string: (imageInfo?.thumbnailImageURL)!) {
                    self?.thumbnailImageView.setImage(withUrl: thumbnailImageURL)
                }
                
                if let profileImageURL = URL(string: (imageInfo?.profileImageURL)!) {
                    self?.profileImageView.setImage(withUrl: profileImageURL)
                }
                
                if let originImageURL = URL(string: (imageInfo?.originImageURL)!) {
                    self?.originalImageView.setImage(withUrl: originImageURL)
                }
            }
        }
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
