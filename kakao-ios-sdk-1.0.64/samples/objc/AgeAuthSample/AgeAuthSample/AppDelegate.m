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

#import "AppDelegate.h"
#import <KakaoOpenSDK/KakaoOpenSDK.h>

@interface AppDelegate ()

@property (nonatomic, strong) UINavigationController *loginViewController;
@property (nonatomic, strong) UINavigationController *mainViewController;
@property (nonatomic, strong) UIViewController *mainTopViewController;

@end

@implementation AppDelegate

- (void)setupEntryController {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.loginViewController = [storyBoard instantiateViewControllerWithIdentifier:@"navigator"];
    self.mainViewController = [storyBoard instantiateViewControllerWithIdentifier:@"navigator"];
    
    UIViewController *viewController = [storyBoard instantiateViewControllerWithIdentifier:@"login"];
    [self.loginViewController pushViewController:viewController animated:YES];
    
    self.mainTopViewController = [storyBoard instantiateViewControllerWithIdentifier:@"main"];
    [self.mainViewController pushViewController:self.mainTopViewController animated:YES];
}

- (void)loadRootViewController {
    [self.mainViewController popToRootViewControllerAnimated:YES];
    self.window.rootViewController = self.loginViewController;
    [self.window makeKeyAndVisible];
}

- (void)reloadRootViewController {
    BOOL isOpened = [KOSession sharedSession].isOpen;
    
    if (!isOpened) {
        [self.mainViewController popToRootViewControllerAnimated:YES];
    }
    
    self.window.rootViewController = isOpened ? self.mainViewController : self.loginViewController;
    [self.window makeKeyAndVisible];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self setupEntryController];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(kakaoSessionDidChangeWithNotification)
                                                 name:KOSessionDidChangeNotification
                                               object:nil];
    
    [self loadRootViewController];
    
    KOSession *session = [KOSession sharedSession];
    session.presentedViewBarTintColor = [UIColor colorWithRed:0x2a / 255.0 green:0x2a / 255.0 blue:0x2a / 255.0 alpha:1.0];
    session.presentedViewBarButtonTintColor = [UIColor colorWithRed:0xe5 / 255.0 green:0xe5 / 255.0 blue:0xe5 / 255.0 alpha:1.0];
    
    return YES;
}

- (void)kakaoSessionDidChangeWithNotification {
    [self reloadRootViewController];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([KOSession isKakaoAccountLoginCallback:url]) {
        return [KOSession handleOpenURL:url];
    }
    return NO;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([KOSession isKakaoAccountLoginCallback:url]) {
        return [KOSession handleOpenURL:url];
    }
    return NO;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    if ([KOSession isKakaoAccountLoginCallback:url]) {
        return [KOSession handleOpenURL:url];
    }
    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [KOSession handleDidEnterBackground];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [KOSession handleDidBecomeActive];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
