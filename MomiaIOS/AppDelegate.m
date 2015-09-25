//
//  AppDelegate.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/4/16.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "URLMappingManager.h"
#import "MONavigationController.h"
//APP端签名相关头文件
#import <AlipaySDK/AlipaySDK.h>
#import "GeTuiSdk.h"

@interface AppDelegate () {
@private
    NSString *_deviceToken;
}

@property (nonatomic, retain) UIImageView *titleShadowIv;

@end

@implementation AppDelegate

- (void)setTitleShadow:(UIImage *)image aboveSubview:(UIView *)view {
    if (_titleShadowIv == nil) {
        _titleShadowIv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 5)];
        [self.window insertSubview:_titleShadowIv aboveSubview:view];
    }
    _titleShadowIv.image = image;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.root = [[MORootViewController alloc] init];
    self.window.rootViewController = self.root;
    [self.window makeKeyAndVisible];
    
    // 微信注册
    [WXApi registerApp:kWechatAppKey];
    
    // 推送相关
    if (![[PushManager shareManager]isPushClose]) {
        [[PushManager shareManager] openPush:self];
        
        // [2-EXT]: 获取启动时收到的APN
        NSDictionary* message = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (message) {
            NSString *payloadMsg = [message objectForKey:@"payload"];
            NSString *record = [NSString stringWithFormat:@"[APN]%@, %@", [NSDate date], payloadMsg];
            NSLog(@"apn message:%@", record);
        }
        
        [self handleRemoteNotification:[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]];
    }
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // 友盟统计
    [MobClick startWithAppkey:kUMengAppKey reportPolicy:BATCH   channelId:MO_APP_CHANNEL];

    return YES;
}

#pragma mark - ShareSDK init


#pragma mark - 'GeTui' push sdk manager
- (void)handleRemoteNotification:(NSDictionary *)dict {
    if (dict) {
        NSString *action = [dict objectForKey:@"action"];
        NSURL *url = [NSURL URLWithString:action];
        [[UIApplication sharedApplication ] openURL:url];
    }
}

#pragma mark - URL Scheme

/* For iOS 4.1 and earlier */
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([url.scheme isEqualToString:@"duola"]) {
        [self handleOpenURL:url];
    }
    
    return [WXApi handleOpenURL:url delegate:self];
}

/* For iOS 4.2 and later */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([url.scheme isEqualToString:@"duola"]) {
        [self handleOpenURL:url];
    }
    
    //如果极简开发包不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给开 发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
                                                      NSLog(@"result = %@",resultDic);
                                                  }]; }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)handleOpenURL:(NSURL *)url
{
    NSLog(@"openURL with url: %@", [url absoluteString]);
    
    [[URLMappingManager sharedManager] handleOpenURL:url byNav:(UINavigationController *)self.root.selectedViewController];
}

#pragma mark - lifecyle

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    if (![[PushManager shareManager]isPushClose]) {
        // [EXT] 切后台关闭SDK，让SDK第一时间断线，让个推先用APN推送
        [[PushManager shareManager]stopSdk];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if (![[PushManager shareManager]isPushClose]) {
        // [EXT] 重新上线
        [[PushManager shareManager]openPush:self];
    }
    
    // config
    [[ConfigService defaultService] refresh];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - system notification

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    if (![[PushManager shareManager]isPushClose]) {
        NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        _deviceToken = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog(@"deviceToken:%@", _deviceToken);
        // [3]:向个推服务器注册 deviceToken
        [GeTuiSdk registerDeviceToken:_deviceToken];
    }
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [GeTuiSdk resume]; // 恢复个推 SDK 运行
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    if (![[PushManager shareManager]isPushClose]) {
        // [3-EXT]:如果 APNS 注册失败,通知个推服务器
        [GeTuiSdk registerDeviceToken:@""];
        
        NSLog(@"didFailToRegisterForRemoteNotificationsWithError:%@", [error localizedDescription]);
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userinfo
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    if (![[PushManager shareManager]isPushClose]) {
        // [4-EXT]:处理APN
        NSString *payloadMsg = [userinfo objectForKey:@"payload"];
        NSLog(@"[APN]%@, %@", [NSDate date], payloadMsg);
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    if (![[PushManager shareManager]isPushClose]) {
        // [4-EXT]:处理APN
        NSString *payloadMsg = [userInfo objectForKey:@"payload"];
        
        NSDictionary *aps = [userInfo objectForKey:@"aps"];
        NSNumber *contentAvailable = aps == nil ? nil : [aps objectForKeyedSubscript:@"content-available"];
        
        NSLog(@"[APN]%@, %@, [content-available: %@]", [NSDate date], payloadMsg, contentAvailable);
        
        completionHandler(UIBackgroundFetchResultNewData);
    }
}

#pragma mark - GexinSdkDelegate
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId
{
    // [4-EXT-1]: 个推SDK已注册
    _sdkStatus = SdkStatusStarted;
    _clientId = nil;
    
    //    [self stopSdk];
}

-(void)GeTuiSdkDidReceivePayload:(NSString*)payloadId andTaskId:(NSString*)taskId andMessageId:(NSString *)aMsgId fromApplication:(NSString *)appId
{
    // [4]: 收到个推消息
    NSData *payload = [GeTuiSdk retrivePayloadById:payloadId];
    NSString *payloadMsg = nil;
    if (payload) {
        payloadMsg = [[NSString alloc] initWithBytes:payload.bytes
                                              length:payload.length
                                            encoding:NSUTF8StringEncoding];
        if (payloadMsg) {
            NSData *jsonData = [payloadMsg dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:nil];
            [self handleRemoteNotification:dic];
        }
    }
    NSLog(@"payloadMsg:%@", payloadMsg);
}

- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // [4-EXT]:发送上行消息结果反馈
    NSLog(@"Received sendmessage:%@ result:%d", messageId, result);
}

- (void)GeTuiSdkDidOccurError:(NSError *)error
{
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"payloadMsg:%@", [NSString stringWithFormat:@">>>[GexinSdk error]:%@", [error localizedDescription]]);
}


#pragma mark - wechat delegate

-(void) onReq:(BaseReq*)req {
    
}

-(void) onResp:(BaseResp*)resp {
    if([resp isKindOfClass:[SendMessageToWXResp class]]) {
        
    } else if ([resp isKindOfClass:[PayResp class]]) {
        
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"payResp" object:resp];
}

//============================================================
// V3&V4支付流程实现
// 注意:参数配置请查看服务器端Demo
// 更新时间：2015年3月3日
// 负责人：李启波（marcyli）
//============================================================
- (void)sendPay:(WechatPayData *)data
{
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.openID              = data.appid;
    req.partnerId           = data.partnerid;
    req.prepayId            = data.prepayid;
    req.nonceStr            = data.noncestr;
    req.timeStamp           = data.timestamp.intValue;
    req.package             = data.package_app;
    req.sign                = data.sign;
    [WXApi sendReq:req];
    //日志输出
    NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",req.openID,req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
}

- (void)sendPay_demo {
}

//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];
}


#pragma mark - weibo delegate

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    
}

@end
