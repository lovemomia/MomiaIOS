//
//  PushManager.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/29.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "PushManager.h"
#import "AppDelegate.h"

@interface PushManager () {
@private
    NSString *_deviceToken;
}
@end

@implementation PushManager

+ (instancetype)shareManager {
    static PushManager *__manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[self alloc] init];
    });
    return __manager;
}

- (void)openPush {
    NSUserDefaults *myDefault =[NSUserDefaults standardUserDefaults];
    [myDefault setBool:NO forKey:@"isPushClose"];
    
    // [1]:使用APPID/APPKEY/APPSECRENT创建个推实例
    [self startSdkWith:kAppId appKey:kAppKey appSecret:kAppSecret];
    
    // [2]:注册APNS
    [self registerRemoteNotification];
}

- (void)closePush {
    NSUserDefaults *myDefault =[NSUserDefaults standardUserDefaults];
    [myDefault setBool:YES forKey:@"isPushClose"];
    
    [self stopSdk];
}

- (BOOL)isPushClose {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isPushClose"];
}

- (void)handleRemoteNotification:(NSDictionary *)dict {
    if (dict) {
        NSString *action = [dict objectForKey:@"action"];
        NSURL *url = [NSURL URLWithString:action];
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret
{
    if (!_gexinPusher) {
        _sdkStatus = SdkStatusStoped;
        
        self.appID = appID;
        self.appKey = appKey;
        self.appSecret = appSecret;
        
        _clientId = nil;
        
        NSError *err = nil;
        _gexinPusher = [GexinSdk createSdkWithAppId:_appID
                                             appKey:_appKey
                                          appSecret:_appSecret
                                         appVersion:@"0.0.0"
                                           delegate:(AppDelegate *)[UIApplication sharedApplication].delegate
                                              error:&err];
        if (!_gexinPusher) {
            NSLog(@"start sdk err:%@", [err localizedDescription]);
        } else {
            _sdkStatus = SdkStatusStarting;
        }
    }
}

- (void)registerRemoteNotification
{
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif
}

- (void)stopSdk
{
    if (_gexinPusher) {
        [_gexinPusher destroy];
        _gexinPusher = nil;
        
        _sdkStatus = SdkStatusStoped;
        
        _clientId = nil;
    }
}

@end
