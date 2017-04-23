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

#import "KakaoLinkActivity.h"
#import <KakaoOpenSDK/KakaoOpenSDK.h>

@implementation KakaoLinkActivity {
    NSString *_activityName;
    NSArray *_linkObjects;
}

- (instancetype)initWithObjects:(NSArray *)objects {
    if (self = [super init]) {
        _activityName = @"KakaoLink";
        _linkObjects = [objects copy];
    }
    
    return self;
}

- (UIImage *)activityImage {
    return [UIImage imageNamed:_activityName];
}

- (NSString *)activityTitle {
    return _activityName;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    return _linkObjects.count > 0 && [KOAppCall canOpenKakaoTalkAppLink];
}

- (void)performActivity {
    [KOAppCall openKakaoTalkAppLink:_linkObjects];
}

@end
