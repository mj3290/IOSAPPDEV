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

#import "MessageViewController.h"
#import "ThumbnailImageViewCell.h"
#import "UIAlertView+Addition.h"
#import "UIImageView+WebCache.h"
#import <KakaoOpenSDK/KakaoOpenSDK.h>
#import "ConfigConstants.h"

typedef NS_ENUM (NSInteger, TalkFriendOptionType) {
    TalkFriendOptionTypeInvitable = 1,
    TalkFriendOptionTypeRegistered
};

@interface MessageViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation MessageViewController {
    NSInteger _limitCount;
    
    KOFriendContext *_friendContext;
    NSMutableArray *_allFriends;
    NSMutableArray *_filteredFriends;
    
    BOOL _requesting;
    TalkFriendOptionType _optionType;
    id _seletedFriend;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _limitCount = 2000;
    _allFriends = [NSMutableArray array];
    _filteredFriends = [NSMutableArray array];
    _optionType = TalkFriendOptionTypeInvitable;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.tableHeaderView = self.searchBar;
    
    self.searchBar.delegate = self;
    self.searchDisplayController.searchResultsTableView.tableFooterView = [[UIView alloc] init];
    
    [self requestMe:NO];
}

- (void)requestMe:(BOOL)displayResult {
    [KOSessionTask meTaskWithCompletionHandler:^(id result, NSError *error) {
        if (error) {
            NSLog(@"requestMe error = %@", error);
            if (error.code == KOErrorCancelled) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } else {
            [_allFriends addObject:result];
            
            [self setupFriendContext];
            [self requestTalkFriends];
        }
    }];
}

- (void)setupFriendContext {
    switch (_optionType) {
        case TalkFriendOptionTypeInvitable:
            _friendContext = [KOFriendContext contextWithServiceType:KOFriendServiceTypeTalk filterType:KOFriendFilterTypeInvitableNotRegistered limit:_limitCount];
            break;
        case TalkFriendOptionTypeRegistered:
            _friendContext = [KOFriendContext contextWithServiceType:KOFriendServiceTypeTalk filterType:KOFriendFilterTypeRegistered limit:_limitCount];
            break;
        default:
            _friendContext = nil;
            break;
    }
}

- (void)requestTalkFriends {
    if (_friendContext == nil) {
        NSLog(@"friendContext must be setup.");
        return;
    }
    
    if (_requesting || !_friendContext.hasMoreItems) {
        return;
    }
    
    _requesting = YES;
    [KOSessionTask friendsWithContext:_friendContext completionHandler:^(NSArray *friends, NSError *error) {
        if (error) {
            NSLog(@"friends error = %@", error);
            if (error.code == KOErrorCancelled) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } else {
            self.title = [NSString stringWithFormat:@"Friends (%@)", _friendContext.totalCount];
            [_allFriends addObjectsFromArray:friends];
            [self.tableView reloadData];
        }
        
        _requesting = NO;
    }];
}

- (IBAction)selectOptions:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Options?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Invitable, Not App Registered", @"App Registered", nil];
    alertView.tag = 1;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) {
        return;
    }
    
    if (alertView.tag == 1) {
        _optionType = (TalkFriendOptionType) buttonIndex;
        [_allFriends removeAllObjects];
        [self.tableView reloadData];
        
        [self setupFriendContext];
        [self requestTalkFriends];
    } else if (alertView.tag == 2) {
        [self sendTemplateMessage];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return _filteredFriends.count;
    }
    
    return _allFriends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ThumbnailImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[ThumbnailImageViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    BOOL isSearchedResult = tableView == self.searchDisplayController.searchResultsTableView;
    
    NSArray *friends = (isSearchedResult ? _filteredFriends : _allFriends);
    id anyObject = friends[indexPath.row];
    
    if ([anyObject isKindOfClass:[KOUser class]]) {
        KOUser *user = (KOUser *)anyObject;
        
        cell.textLabel.text = @"ToMe(나와의 채팅방)";
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:user.properties[@"thumbnail_image"]]
                          placeholderImage:[UIImage imageNamed:@"PlaceHolder"]];
    } else {
        KOFriend *friend = (KOFriend *)anyObject;
        
        cell.textLabel.text = friend.nickName;
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:friend.thumbnailURL]
                          placeholderImage:[UIImage imageNamed:@"PlaceHolder"]];
    }
    
    if (tableView == self.tableView) {
        NSInteger count = friends.count;
        if (indexPath.row > (count - count / 3)) {
            [self requestTalkFriends];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *friends = (tableView == self.searchDisplayController.searchResultsTableView ? _filteredFriends : _allFriends);
    _seletedFriend = friends[indexPath.row];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Send Message?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alertView.tag = 2;
    [alertView show];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [_filteredFriends removeAllObjects];
    
    if (searchText.length == 0) {
        return;
    }
    
    for (id friend in _allFriends) {
        NSString *nickName = nil;
        if ([friend isKindOfClass:[KOFriend class]]) {
            nickName = ((KOFriend*)friend).nickName;
        } else if ([friend isKindOfClass:[KOUser class]]) {
            nickName = ((KOUser*)friend).properties[@"nickname"];
        }
        
        if (nickName && [nickName rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
            [_filteredFriends addObject:friend];
        }
    }
    
    [self.tableView reloadData];
}

- (void)sendTemplateMessage {
    if (_seletedFriend == nil) {
        return;
    }
    
    id anyObject = _seletedFriend;
    _seletedFriend = nil;
    
    if ([anyObject isKindOfClass:[KOUser class]]) {
        KOUser *user = (KOUser *)anyObject;
        
        [user sendMemoWithTemplateID:@MESSAGE_VIEW_CONTROLLER_TEMPLATE_ID
                    messageArguments:@{@"MESSAGE":@"안녕하세요? 나와의 채팅방으로 보낸 메세지입니다.", @"DATE":@"2016-XX-XX(objective-c)"}
                   completionHandler:^(NSError *error) {
                       if (error) {
                           if (error.code != KOErrorOperationInProgress) {
                               [UIAlertView showMessage:[NSString stringWithFormat:@"message send failed = %@", error]];
                           }
                       } else {
                           [UIAlertView showMessage:@"message send succeed."];
                       }
                   }];
    } else {
        KOFriend *friend = (KOFriend *)anyObject;
        
        if (!friend.allowedTalkMessaging) {
            [UIAlertView showMessage:@"friend set message blocked."];
            return;
        }
        
        if (_optionType == TalkFriendOptionTypeInvitable) {
            NSString *templateID = @"9";  // invite template message id
            [friend sendMessageWithTemplateID:templateID
                                    arguments:@{@"name":friend.nickName, @"iphoneMarketParam":@"test", @"iphoneExecParam":@"test"}
                            completionHandler:^(NSError *error) {
                                if (error) {
                                    if (error.code != KOErrorOperationInProgress) {
                                        [UIAlertView showMessage:[NSString stringWithFormat:@"message send failed = %@", error]];
                                    }
                                } else {
                                    [UIAlertView showMessage:@"message send succeed."];
                                }
                            }];
        } else {
            NSString *templateID = @"10";  // feed template message id
            [friend sendMessageWithTemplateID:templateID
                                    arguments:@{@"msg":@"새로운 연결, 새로운 세상.", @"iphoneMarketParam":@"test", @"iphoneExecParam":@"test"}
                            completionHandler:^(NSError *error) {
                                if (error) {
                                    if (error.code != KOErrorOperationInProgress) {
                                        [UIAlertView showMessage:[NSString stringWithFormat:@"message send failed = %@", error]];
                                    }
                                } else {
                                    [UIAlertView showMessage:@"message send succeed."];
                                }
                            }];
        }
    }
}

@end
