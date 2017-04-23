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

#import "ChatMessageViewController.h"
#import "ThumbnailImageViewCell.h"
#import "UIAlertView+Addition.h"
#import "UIImageView+WebCache.h"
#import <KakaoOpenSDK/KakaoOpenSDK.h>

@interface ChatMessageViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ChatMessageViewController {
    NSMutableArray *_chatList;
    NSMutableArray *_filteredChatList;
    KOChat *_selectedChat;
    KOChatContext *_chatContext;
    BOOL _requesting;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // it will be deprecated in the near future.
    // _chatContext = [KOChatContext contextWithChatType:KOChatTypeGroup limit:30 ordering:KOOrderingAscending];
    
    _chatContext = [KOChatContext contextWithChatFilters:KOChatFilterNone limit:30 ordering:KOOrderingAscending];
    _chatList = [NSMutableArray array];
    _filteredChatList = [NSMutableArray array];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.tableHeaderView = self.searchBar;
    
    self.searchBar.delegate = self;
    self.searchDisplayController.searchResultsTableView.tableFooterView = [[UIView alloc] init];
    
    [self requestChatList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestChatList {
    if (_chatContext == nil) {
        NSLog(@"chatContext must be setup.");
        return;
    }
    
    if (_requesting || !_chatContext.hasMoreItems) {
        return;
    }
    
    _requesting = YES;
    [KOSessionTask talkChatListTaskWithContext:_chatContext completionHandler:^(NSArray *chats, NSError *error) {
        if (error) {
            NSLog(@"chats error = %@", error);
            if (error.code == KOErrorCancelled) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } else {
            self.title = [NSString stringWithFormat:@"Chat (%@)", _chatContext.totalCount];
            [_chatList addObjectsFromArray:chats];
            [self.tableView reloadData];
        }
        
        _requesting = NO;
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) {
        return;
    }
    
    [self sendTemplateMessage];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return _filteredChatList.count;
    }
    
    return _chatList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ThumbnailImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[ThumbnailImageViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    NSArray *chats = (tableView == self.searchDisplayController.searchResultsTableView ? _filteredChatList : _chatList);
    KOChat *chat = chats[indexPath.row];
    
    cell.textLabel.text = chat.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Members : %@", chat.memberCount];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:chat.thumbnailURL]
                      placeholderImage:[UIImage imageNamed:@"PlaceHolder"]];
    
    if (tableView == self.tableView) {
        NSInteger count = chats.count;
        if (indexPath.row > (count - count / 3)) {
            [self requestChatList];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *chats = (tableView == self.searchDisplayController.searchResultsTableView ? _filteredChatList : _chatList);
    _selectedChat = chats[indexPath.row];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Send Message?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alertView show];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [_filteredChatList removeAllObjects];
    
    if (searchText.length == 0) {
        return;
    }
    
    for (KOChat *chat in _chatList) {
        if ([chat.title rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
            [_filteredChatList addObject:chat];
        }
    }
    
    [self.tableView reloadData];
}

- (void)sendTemplateMessage {
    if (_selectedChat == nil) {
        return;
    }
    
    KOChat *chat = _selectedChat;
    _selectedChat = nil;
    
    NSString *templateID = @"10";  // feed template message id
    [chat sendMessageWithTemplateID:templateID
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


@end
