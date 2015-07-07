//
//  AppDelegate.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/4/16.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GexinSdk.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import "WechatPayDelegate.h"
#import "MORootViewController.h"

typedef enum {
    SdkStatusStoped,
    SdkStatusStarting,
    SdkStatusStarted
} SdkStatus;

@interface AppDelegate : UIResponder <UIApplicationDelegate, GexinSdkDelegate, WXApiDelegate, WeiboSDKDelegate, WechatPayDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MORootViewController *root;

@property (strong, nonatomic) GexinSdk *gexinPusher;

@property (retain, nonatomic) NSString *appKey;
@property (retain, nonatomic) NSString *appSecret;
@property (retain, nonatomic) NSString *appID;
@property (retain, nonatomic) NSString *clientId;
@property (assign, nonatomic) SdkStatus sdkStatus;

@end

