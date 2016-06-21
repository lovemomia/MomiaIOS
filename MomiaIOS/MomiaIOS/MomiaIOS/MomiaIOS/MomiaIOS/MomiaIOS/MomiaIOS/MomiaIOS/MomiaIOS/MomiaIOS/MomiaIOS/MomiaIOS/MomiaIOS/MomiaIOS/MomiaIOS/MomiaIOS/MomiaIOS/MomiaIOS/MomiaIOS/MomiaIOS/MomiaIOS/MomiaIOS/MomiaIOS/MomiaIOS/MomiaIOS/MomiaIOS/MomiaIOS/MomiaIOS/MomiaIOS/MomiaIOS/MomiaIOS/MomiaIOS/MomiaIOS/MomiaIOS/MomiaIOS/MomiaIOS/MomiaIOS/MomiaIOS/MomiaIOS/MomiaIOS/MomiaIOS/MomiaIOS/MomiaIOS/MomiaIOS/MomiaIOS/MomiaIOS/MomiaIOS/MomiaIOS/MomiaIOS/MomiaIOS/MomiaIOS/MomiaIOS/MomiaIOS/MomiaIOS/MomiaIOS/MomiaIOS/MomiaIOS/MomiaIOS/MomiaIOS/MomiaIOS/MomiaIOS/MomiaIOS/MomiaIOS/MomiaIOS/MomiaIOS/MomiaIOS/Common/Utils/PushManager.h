//
//  PushManager.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/29.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeTuiSdk.h"

@interface PushManager : NSObject

@property (retain, nonatomic) NSString *appKey;
@property (retain, nonatomic) NSString *appSecret;
@property (retain, nonatomic) NSString *appID;
@property (retain, nonatomic) NSString *clientId;
@property (assign, nonatomic) SdkStatus sdkStatus;

+ (instancetype)shareManager;

- (void)openPush:(id<GeTuiSdkDelegate>)delegate ;

- (void)closePush;

- (void)stopSdk;

- (BOOL)isPushClose;

@end
