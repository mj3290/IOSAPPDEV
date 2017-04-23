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

/*!
 @header KS2Session.h
 S2 이벤트 로깅 기능을 제공합니다. 이벤트를 추가하면 주기적으로 큐를 체크하여 일괄 전송합니다.
 */

#import <Foundation/Foundation.h>

@class KS2Event;

/*!
 @class KS2Session
 @abstract S2 API 세션 관리 클래스.
 */
@interface KS2Session : NSObject

/*!
 @property batchSize
 @abstract 이벤트 큐 사이즈.
 */
@property (assign) NSUInteger batchSize;

/*!
 @property batchTime
 @abstract 이벤트 전송 주기.
 */
@property (assign) NSUInteger batchTime;

/*!
 @abstract 현재 session 정보
 */
+ (instancetype)sharedSession;

/*!
 application이 active 상태로 변경시 session 활성화한다. 보통 applicationDidBecomeActive에서 해당 부분을 호출한다.
 */
- (void)handleDidBecomeActive;

/*!
 application이 background 상태로 변경시 비활성화 처리를 한다. 보통 applicationDidEnterBackground에서 해당 부분을 호출한다.
 */
- (void)handleDidEnterBackground;

/*!
 큐에 이벤트를 추가한다. 큐에 batchSize만큼 이벤트가 쌓이면 서버로 전송한다.
 @param event 추가할 KS2Event 이벤트.
 */
- (void)addEvent:(KS2Event *)event;

/*!
 현재 큐에 쌓여있는 이벤트를 서버로 강제 전송한다.
 */
- (void)publish;

@end
