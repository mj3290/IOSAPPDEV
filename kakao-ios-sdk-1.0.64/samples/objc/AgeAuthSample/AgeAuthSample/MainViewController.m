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


#import "MainViewController.h"
#import "UIAlertView+Addition.h"
#import <KakaoOpenSDK/KakaoOpenSDK.h>
#import <stdlib.h>

@interface MainViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *authPolicyPicker;

@end

@implementation MainViewController {
    NSArray *_authPolicyMenus;
    NSInteger _selectPolicyIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _authPolicyMenus = @[@"앱 설정 (15세/1차)", @"19세/2차", @"19세/2차/CI", @"19세/2차/CI/30일 이내"];
    
    [KOSessionTask meTaskWithCompletionHandler:^(id result, NSError *error) {
        if (error) {
            [KOSessionTask signupTaskWithProperties:nil completionHandler:^(BOOL success, NSError *error) {
                if (error != nil) {
                    [UIAlertView showMessage:@"Signup 에 실패했습니다. 로그아웃 후 재로그인 해보세요!"];
                } else {
                    [UIAlertView showMessage:@"Signup 에 성공했습니다!"];
                }
            }];
        }
    }];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _authPolicyMenus.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _authPolicyMenus[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _selectPolicyIndex = row;
}

- (IBAction)logout:(id)sender {
    __weak MainViewController *wself = self;
    [[KOSession sharedSession] logoutAndCloseWithCompletionHandler:^(BOOL success, NSError *error) {
        [wself.navigationController popViewControllerAnimated:YES];
    }];
}

- (IBAction)unlinkClicked:(id)sender {
    [KOSessionTask unlinkTaskWithCompletionHandler:^(BOOL success, NSError *error) {
        if (success) {
            [self logout:sender];
        } else {
            [UIAlertView showMessage:error.description];
        }
    }];
}

- (IBAction)ageAuthClicked:(id)sender {
    // -- [주의] --
    // 연령인증 웹뷰를 실행하기 전, 사용자의 연령인증정보를 요청하고 자신의 서비스 연령인증 기준에 맞춰 인증여부를 판단해야 한다.
    
    if (_selectPolicyIndex == 0) {
        // case 앱 설정 (15세/1차)
        
        // 인증정보 확인. KOAgeAuthLimitTypeNone을 넘겨주면 앱에 설정된 나이로 판별함.
        [KOSessionTask ageAuthTaskWithCompletionHandler:KOAgeAuthLimitTypeNone propertyKeys:nil completionHandler:^(id result, NSError *error) {
            if (error) {
                [UIAlertView showMessage:error.description];
            } else {
                
                // 샘플 앱에 설정된 인증레벨이 1차인증이므로 인증레벨 상관없이 연령통과가 참이면 인증 필요 없음.
                if ([result[KOAgeAuthBypassLimitKey] boolValue]) {
                    [UIAlertView showMessage:@"이 사용자는 새로운 연령인증이 필요없는 상태입니다."];
                } else {
                    
                    // 앱 설정 (15세/1차)로 연령인증 웹뷰 실행.
                    [[KOSession sharedSession] showAgeAuthWithAuthLevel:nil completionHandler:^(BOOL success, NSError *error) {
                        if (success) {
                            [UIAlertView showMessage:@"연령인증에 성공했습니다."];
                        } else {
                            [UIAlertView showMessage:error.description];
                        }
                    }];
                }
            }
        }];
        
    } else if (_selectPolicyIndex == 1) {
        // case 19세/2차
        
        // 인증정보 확인. 19세 기준으로 인증정보를 요청함.
        KOAgeAuthLimit authLimit = KOAgeAuthLimitType19;
        [KOSessionTask ageAuthTaskWithCompletionHandler:authLimit propertyKeys:nil completionHandler:^(id result, NSError *error) {
            if (error) {
                [UIAlertView showMessage:error.description];
            } else {
                
                // 2차 인증을 필요로 하므로 인증레벨코드가 2 이상이고 연령통과가 참이면 패스.
                if ([result[KOAgeAuthLevelCodeKey] intValue] >= 2 &&
                    [result[KOAgeAuthBypassLimitKey] boolValue]) {
                    [UIAlertView showMessage:@"이 사용자는 새로운 연령인증이 필요없는 상태입니다."];
                } else {
                    
                    // 19세/2차로 연령인증 웹뷰 실행.
                    KOAgeAuthQueryStringBuilder *ageAuthQueryStringBuilder = [[KOAgeAuthQueryStringBuilder alloc] init];
                    ageAuthQueryStringBuilder.level = KOAgeAuthLevelType2;
                    ageAuthQueryStringBuilder.limit = KOAgeAuthLimitType19;
                    [[KOSession sharedSession] showAgeAuthWithAuthLevel:ageAuthQueryStringBuilder completionHandler:^(BOOL success, NSError *error) {
                        if (success) {
                            [UIAlertView showMessage:@"연령인증에 성공했습니다."];
                        } else {
                            [UIAlertView showMessage:error.description];
                        }
                    }];
                }
            }
        }];
        
    } else if (_selectPolicyIndex == 2) {
        // case 19세/2차/CI
        
        // 인증정보 확인. 19세를 기준으로 CI를 포함한 인증정보 요청.
        KOAgeAuthLimit authLimit = KOAgeAuthLimitType19;
        NSSet *propertyKeys = [NSSet setWithObject:@(KOAgeAuthPropertyAccountCi)];
        [KOSessionTask ageAuthTaskWithCompletionHandler:authLimit propertyKeys:propertyKeys completionHandler:^(id result, NSError *error) {
            if (error) {
                [UIAlertView showMessage:error.description];
            } else {
                
                // 인증레벨코드 2 이상, 연령통과, CI값 존재
                if ([result[KOAgeAuthLevelCodeKey] intValue] >= 2 &&
                    [result[KOAgeAuthBypassLimitKey] boolValue] &&
                    result[KOAgeAuthCIKey]) {
                    [UIAlertView showMessage:@"이 사용자는 새로운 연령인증이 필요없는 상태입니다."];
                } else {
                    
                    // 19세/2차로 연령인증 웹뷰 실행.
                    KOAgeAuthQueryStringBuilder *ageAuthQueryStringBuilder = [[KOAgeAuthQueryStringBuilder alloc] init];
                    ageAuthQueryStringBuilder.level = KOAgeAuthLevelType2;
                    ageAuthQueryStringBuilder.limit = KOAgeAuthLimitType19;
                    [[KOSession sharedSession] showAgeAuthWithAuthLevel:ageAuthQueryStringBuilder completionHandler:^(BOOL success, NSError *error) {
                        if (success) {
                            [UIAlertView showMessage:@"연령인증에 성공했습니다."];
                        } else {
                            [UIAlertView showMessage:error.description];
                        }
                    }];
                }
            }
        }];
        
    } else {
        // case 19세/2차/CI/30일 이내
        
        // 인증정보 확인. 19세를 기준으로 CI를 포함한 인증정보 요청.
        KOAgeAuthLimit authLimit = KOAgeAuthLimitType19;
        NSSet *propertyKeys = [NSSet setWithObject:@(KOAgeAuthPropertyAccountCi)];
        [KOSessionTask ageAuthTaskWithCompletionHandler:authLimit propertyKeys:propertyKeys completionHandler:^(id result, NSError *error) {
            if (error) {
                [UIAlertView showMessage:error.description];
            } else {
                
                // 인증날짜 추출. RFC3339 internet date/time format
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
                formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
                NSDate *authDate = [formatter dateFromString:[result[KOAgeAuthDateKey] description]];
                
                // 인증레벨코드 2 이상, 연령통과, CI값 존재, 30일 이내
                if ([result[KOAgeAuthBypassLimitKey] boolValue] &&
                    [result[KOAgeAuthLevelCodeKey] intValue] >= 2 &&
                    result[KOAgeAuthCIKey] &&
                    [authDate timeIntervalSinceNow] + 30 * 24 * 60 * 60 >= 0) {
                    [UIAlertView showMessage:@"이 사용자는 새로운 연령인증이 필요없는 상태입니다."];
                } else {
                    
                    // 19세/2차로 연령인증 웹뷰 실행.
                    KOAgeAuthQueryStringBuilder *builder = [[KOAgeAuthQueryStringBuilder alloc] init];
                    builder.level = KOAgeAuthLevelType2;
                    builder.limit = KOAgeAuthLimitType19;
                    [[KOSession sharedSession] showAgeAuthWithAuthLevel:builder completionHandler:^(BOOL success, NSError *error) {
                        if (success) {
                            [UIAlertView showMessage:@"연령인증에 성공했습니다."];
                        } else {
                            [UIAlertView showMessage:error.description];
                        }
                    }];
                }
            }
        }];
    }

}


@end
