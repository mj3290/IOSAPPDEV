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

#import "ViewController.h"
#import "IconTableViewCell.h"
#import "KakaoLinkActivity.h"
#import <KakaoOpenSDK/KakaoOpenSDK.h>

#import "StoryLinkHelper.h"
#import "StoryPostingActivity.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UIDocumentInteractionControllerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController {
    NSArray *_menuItems;
    NSArray *_menuItemSubTexts;
    UIDocumentInteractionController *_documentController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _menuItems = @[@"Send Link", @"Send Link", @"Share File", @"Story Posting"];
    _menuItemSubTexts = @[@"", @"(UIActivityViewController)", @"(UIDocumentInteractionController)", @""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)dummyLinkObjects {
    KakaoTalkLinkObject *label = [KakaoTalkLinkObject createLabel:@"Test Label\nNext Line"];
    KakaoTalkLinkObject *image = [KakaoTalkLinkObject createImage:@"https://developers.kakao.com/assets/img/link_sample.jpg" width:138 height:80];
    KakaoTalkLinkObject *webLink = [KakaoTalkLinkObject createWebLink:@"Test Link" url:@"http://www.kakao.com"];
    
    KakaoTalkLinkAction *androidAppAction = [KakaoTalkLinkAction createAppAction:KakaoTalkLinkActionOSPlatformAndroid devicetype:KakaoTalkLinkActionDeviceTypePhone execparam:@{@"test1" : @"test1", @"test2" : @"test2"}];
    KakaoTalkLinkAction *iphoneAppAction = [KakaoTalkLinkAction createAppAction:KakaoTalkLinkActionOSPlatformIOS devicetype:KakaoTalkLinkActionDeviceTypePhone execparam:@{@"test1" : @"test1", @"test2" : @"test2"}];
    KakaoTalkLinkAction *ipadAppAction = [KakaoTalkLinkAction createAppAction:KakaoTalkLinkActionOSPlatformIOS devicetype:KakaoTalkLinkActionDeviceTypePad execparam:@{@"test1" : @"test1", @"test2" : @"test2"}];
    KakaoTalkLinkObject *appLink = [KakaoTalkLinkObject createAppButton:@"Test Button" actions:@[androidAppAction, iphoneAppAction, ipadAppAction]];

    return @[label, image, webLink, appLink];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IconTableViewCell"];
    if (cell == nil) {
        cell = [[IconTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"IconTableViewCell"];
    }
    
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"LinkIcon%d", (int) indexPath.row]];
    cell.textLabel.text = _menuItems[indexPath.row];
    cell.detailTextLabel.text = _menuItemSubTexts[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
            [self sendLink];
            break;
        case 1:
            [self showActivity];
            break;
        case 2:
            [self showChooseSharingFile];
            break;
        case 3:
            [self postStory];
            break;
        default:
            break;
    }
}

- (void)sendLink {
    if ([KOAppCall canOpenKakaoTalkAppLink]) {
        [KOAppCall openKakaoTalkAppLink:[self dummyLinkObjects]];
    } else {
        NSLog(@"Cannot open kakaotalk.");
    }
}

- (void)showActivity {
    UIActivity *activity = [[KakaoLinkActivity alloc] initWithObjects:[self dummyLinkObjects]];
    UIActivity *storyActivity = [[StoryPostingActivity alloc] initWithLinkURLString:[self dummyStoryLinkURLString]];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[activity.activityTitle, storyActivity.activityTitle]
                                                                                         applicationActivities:@[activity, storyActivity]];
    
    [self presentViewController:activityViewController animated:YES completion:nil];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad
        && [activityViewController respondsToSelector:@selector(popoverPresentationController)]) {
        activityViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        activityViewController.popoverPresentationController.sourceView = self.view;
        activityViewController.popoverPresentationController.sourceRect = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 0, 0);
    }
}

- (void)showChooseSharingFile {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"공유 파일?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"JPG", @"MP4", @"TXT", @"GIF", nil];
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:
            [self shareFile:[[NSBundle mainBundle] URLForResource:@"test_img" withExtension:@"jpg"]];
            break;
        case 2:
            [self shareFile:[[NSBundle mainBundle] URLForResource:@"test_vod" withExtension:@"mp4"]];
            break;
        case 3:
            // kakaotalk not support yet.
            [self shareFile:[[NSBundle mainBundle] URLForResource:@"test_text" withExtension:@"txt"]];
            break;
        case 4:
            // kakaotalk not support yet.
            [self shareFile:[[NSBundle mainBundle] URLForResource:@"test_gif" withExtension:@"gif"]];
            break;
        default:
            break;
    }
}

- (void)shareFile:(NSURL *)localPath {
    _documentController = [[UIDocumentInteractionController alloc] init];
    _documentController.URL = localPath;
    _documentController.delegate = self;
    [_documentController presentOptionsMenuFromRect:self.view.frame inView:self.view animated:YES];
}

- (void)documentInteractionControllerDidDismissOptionsMenu:(UIDocumentInteractionController *)controller {
    _documentController = nil;
}

- (NSString *)dummyStoryLinkURLString {
    NSBundle *bundle = [NSBundle mainBundle];
    ScrapInfo *scrapInfo = [[ScrapInfo alloc] init];
    scrapInfo.title = @"Sample";
    scrapInfo.desc = @"Sample 입니다.";
    scrapInfo.imageURLs = @[@"http://www.daumkakao.com/images/operating/temp_mov.jpg"];
    scrapInfo.type = ScrapTypeVideo;
    
    return [StoryLinkHelper makeStoryLinkWithPostingText:@"Sample Story Posting https://www.youtube.com/watch?v=XUX1jtTKkKs"
                                             appBundleID:[bundle bundleIdentifier]
                                              appVersion:[bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
                                                 appName:[bundle objectForInfoDictionaryKey:@"CFBundleName"]
                                               scrapInfo:scrapInfo];
}

- (void)postStory {
    if (![StoryLinkHelper canOpenStoryLink]) {
        NSLog(@"Cannot open kakao story.");
        return;
    }
    
    [StoryLinkHelper openStoryLinkWithURLString:[self dummyStoryLinkURLString]];
}


@end
