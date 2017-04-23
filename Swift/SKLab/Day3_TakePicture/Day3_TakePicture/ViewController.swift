//
//  ViewController.swift
//  Day3_TakePicture
//
//  Created by Kim Dong-woo on 2017. 4. 14..
//  Copyright © 2017년 Kim Dong-woo. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
       
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        iamgeView.image = image
        
        picker.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            print("authorized")
        case .denied:
            print("denied")
        case .notDetermined:
            print("notDetermined")
           // alertToEncouragePhotoLibraryAccessWhenApplicationStarts()
        case .restricted:
            print("restricted")
        }
        
    }
    
//    func alertToEncouragePhotoLibraryAccessWhenApplicationStarts()
//    {
//        //Photo Library not available - Alert
//        let cameraUnavailableAlertController = UIAlertController (title: "Photo Library Unavailable", message: "Please check to see if device settings doesn't allow photo library access", preferredStyle: .alert)
//        
//        let settingsAction = UIAlertAction(title: "Settings", style: .destructive) { (_) -> Void in
//            let settingsUrl = NSURL(string:UIApplicationOpenSettingsURLString)
//            if let url = settingsUrl {
//                if #available(iOS 10.0, *) {
//                    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
//                } else {
//                    // Fallback on earlier versions
//                }
//            }
//        }
//        let cancelAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
//        cameraUnavailableAlertController .addAction(settingsAction)
//        cameraUnavailableAlertController .addAction(cancelAction)
//        self.present(cameraUnavailableAlertController , animated: true, completion: nil)
//    }

    @IBOutlet weak var iamgeView: UIImageView!

    @IBAction func pickImage(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
        
    }

}

