//
//  PushManager.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/29.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "PushManager.h"
#import "AppDelegate.h"
#import "GeTuiSdk.h"

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

- (void)openPush:(id<GeTuiSdkDelegate>)delegate {
    NSUserDefaults *myDefault =[NSUserDefaults standardUserDefaults];
    [myDefault setBool:NO forKey:@"isPushClose"];
    
    // [1]:使用APPID/APPKEY/APPSECRENT创建个推实例
    [self startSdkWith:kAppId appKey:kAppKey appSecret:kAppSecret delegate:delegate];
    
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

- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret delegate:(id<GeTuiSdkDelegate>)delegate
{
    NSError *err = nil;
    //[1-1]:通过 AppId、 appKey 、appSecret 启动 SDK
    [GeTuiSdk startSdkWithAppId:appID appKey:appKey appSecret:appSecret delegate:delegate
                          error:&err];
    //[1-2]:设置是否后台运行开关
    [GeTuiSdk runBackgroundEnable:YES];
    //[1-3]:设置地理围栏功能,开启 LBS 定位服务和是否允许 SDK 弹出用户定位请求,请求
    //NSLocationAlwaysUsageDescription 权限,如果 UserVerify 设置为 NO,需第三方负责提示用户定位授权。
    [GeTuiSdk lbsLocationEnable:YES andUserVerify:YES];
    if (err) {
        NSLog(@"start sdk err:%@", [err localizedDescription]);
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
    // [EXT] APP 进入后台时,通知个推 SDK 进入后台
    [GeTuiSdk enterBackground];
}

@end
