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

#import "StorageViewController.h"
#import "UIAlertView+Addition.h"
#import "UIImageView+WebCache.h"
#import <KakaoOpenSDK/KakaoOpenSDK.h>

@interface StorageViewController() <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *originalImageView;

@end

@implementation StorageViewController {
    UIPopoverController *_popoverController;
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)upload:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.allowsEditing = NO;
    picker.delegate = self;
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        _popoverController = [[UIPopoverController alloc] initWithContentViewController:picker];
        [_popoverController presentPopoverFromRect:CGRectMake(0, 0, 400, 400) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else {
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissImagePickerViewController];
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if(!image) {
        image = info[UIImagePickerControllerOriginalImage];
        
        if (image == nil) {
            return;
        }
    }
    
    __weak StorageViewController *wself = self;
    [KOSessionTask storageImageUploadTaskWithImage:image
                                    secureResource:NO
                                 completionHandler:^(KOStorageImageInfo *imageInfo, NSError *error) {
                                     if (error) {
                                         [UIAlertView showMessage:[NSString stringWithFormat:@"upload image error = %@", error.description]];
                                     } else {
                                         [wself.thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:imageInfo.thumbnailImageURL]];
                                         [wself.profileImageView sd_setImageWithURL:[NSURL URLWithString:imageInfo.profileImageURL]];
                                         [wself.originalImageView sd_setImageWithURL:[NSURL URLWithString:imageInfo.originImageURL]];
                                     }
                                 }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissImagePickerViewController];
}

- (void)dismissImagePickerViewController {
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        [_popoverController dismissPopoverAnimated:YES];
        _popoverController = nil;
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
