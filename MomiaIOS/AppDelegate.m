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
#import <AlipaySDK/AlipaySDK.h>
#import "GeTuiSdk.h"
#import <RongIMKit/RongIMKit.h>

#import "IMTokenModel.h"
#import "IMUserModel.h"
#import "IMGroupModel.h"

@interface AppDelegate ()<RCIMUserInfoDataSource, RCIMGroupInfoDataSource, RCIMReceiveMessageDelegate> {
@private
    NSString *_deviceToken;
}

@property (nonatomic, retain) UIImageView *titleShadowIv;
@property (nonatomic) BOOL isLaunchedByNotification;

@end

@implementation AppDelegate
@synthesize imUserDic;
@synthesize imGroupDic;

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
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    if (MO_DEBUG == 1) {
        [MobClick setLogEnabled:YES];
        [self printDeviceID];
    }
    
    // config
    [[ConfigService defaultService] refresh];
    
    // 定位sdk
    [[LocationService defaultService] start];
    
    //初始化融云SDK。
    [[RCIM sharedRCIM] initWithAppKey:(MO_DEBUG == 0 ? kRCIMAppKey : kRCIMAppKey_QA)];
    [RCIM sharedRCIM].globalNavigationBarTintColor = MO_APP_ThemeColor;
    [RCIM sharedRCIM].globalConversationAvatarStyle = RC_USER_AVATAR_CYCLE;
    [RCIM sharedRCIM].globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
    [RCIM sharedRCIM].receiveMessageDelegate = self;
    // 设置用户信息提供者。
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    // 设置群组信息提供者。
    [[RCIM sharedRCIM] setGroupInfoDataSource:self];
    
    // 快速集成第二步，连接融云服务器
    if ([[AccountService defaultService]isLogin]) {
        
        // 如果是老用户，刷新一下imToken
        NSString *imToken = [AccountService defaultService].account.imToken;
        if (imToken.length > 0) {
            [self doRCIMConnect:imToken tryTime:3];
            
        } else {
            [[HttpService defaultService] GET:URL_APPEND_PATH(@"/im/token") parameters:nil cacheType:CacheTypeDisable JSONModelClass:[IMTokenModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                IMTokenModel *model = responseObject;
                [AccountService defaultService].account.imToken = model.data;
                [self doRCIMConnect:imToken tryTime:3];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"refresh imtoken failed");
            }];
        }
    }
    
    /**
     * 统计推送打开率1
     */
    [[RCIMClient sharedRCIMClient] recordLaunchOptionsEvent:launchOptions];
    
    /**
     * 获取融云推送服务扩展字段1
     */
    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient] getPushExtraFromLaunchOptions:launchOptions];
    if (pushServiceData) {
        self.isLaunchedByNotification = YES;
        
    } else {
        self.isLaunchedByNotification = NO;
    }
    
    /**
     * 推送处理1
     */
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, iOS 8
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
        
    } else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }

    return YES;
}

#pragma mark - umeng
- (void)printDeviceID {
    Class cls = NSClassFromString(@"UMANUtil");
    SEL deviceIDSelector = @selector(openUDIDString);
    NSString *deviceID = nil;
    if(cls && [cls respondsToSelector:deviceIDSelector]){
        deviceID = [cls performSelector:deviceIDSelector];
    }
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    
    NSLog(@"UMeng deviceId: %@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
}


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
    
    if (![[PushManager shareManager] isPushClose]) {
        // [EXT] 切后台关闭SDK，让SDK第一时间断线，让个推先用APN推送
        [[PushManager shareManager] stopSdk];
    }
    [[LocationService defaultService] stop];
    
    int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                         @(ConversationType_PRIVATE),
                                                                         @(ConversationType_GROUP)
                                                                         ]];
    application.applicationIconBadgeNumber = unreadMsgCount;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    // config
    [[ConfigService defaultService] refresh];
    
    // 定位sdk
    [[LocationService defaultService] start];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if (![[PushManager shareManager] isPushClose]) {
        // [EXT] 重新上线
        [[PushManager shareManager]openPush:self];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - system notification
/**
 * 推送处理2
 */
//注册用户通知设置
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    if (![[PushManager shareManager]isPushClose]) {
        NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        _deviceToken = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog(@"deviceToken:%@", _deviceToken);
        // [3]:向个推服务器注册 deviceToken
        [GeTuiSdk registerDeviceToken:_deviceToken];
    }
    
    NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceToken2:%@", token);
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
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

- (void)didReceiveMessageNotification:(NSNotification *)notification {
    [UIApplication sharedApplication].applicationIconBadgeNumber =
    [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    /**
     * 统计推送打开率3
     */
    [[RCIMClient sharedRCIMClient] recordLocalNotificationEvent:notification];
    
    NSDictionary *userInfo = notification.userInfo;
    [self handlerUserInfo:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    if (![[PushManager shareManager]isPushClose]) {
        // [4-EXT]:处理APN
        NSString *payloadMsg = [userInfo objectForKey:@"payload"];
        NSLog(@"[APN]%@, %@", [NSDate date], payloadMsg);
    }
    
    [self handlerUserInfo:userInfo];
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
    
    [self handlerUserInfo:userInfo];
}

- (void)handlerUserInfo:(NSDictionary *)userInfo {
    /**
     * 统计推送打开率2
     */
    [[RCIMClient sharedRCIMClient] recordRemoteNotificationEvent:userInfo];
    /**
     * 获取融云推送服务扩展字段2
     */
//    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient] getPushExtraFromRemoteNotification:userInfo];
//    if (pushServiceData) {
//        NSString *action = [pushServiceData objectForKey:@"action"];
//        [[UIApplication sharedApplication ] openURL:[NSURL URLWithString:action]];
//    }
    
//    NSString *pushData = [userInfo objectForKey:@"pushData"];
//    if (pushData.length > 0 && [pushData containsString:@"duola://"]) {
//        [[UIApplication sharedApplication ] openURL:[NSURL URLWithString:pushData]];
//    }
    
    if (userInfo) {
        NSDictionary *rc = [userInfo objectForKey:@"rc"];
        if (rc) {
            NSString *cType = [rc objectForKey:@"cType"];
            if ([cType isEqualToString:@"SYS"]) {
                NSString *fId = [rc objectForKey:@"fId"];
                NSArray *messageArray = [[RCIMClient sharedRCIMClient] getLatestMessages:ConversationType_SYSTEM targetId:fId count:1];
                if (messageArray.count > 0) {
                    RCMessage *message = messageArray[0];
                    if ([message.content isKindOfClass:[RCTextMessage class]]) {
                        NSString *pushData = ((RCTextMessage *)message.content).extra;
                        if (pushData.length > 0 && [pushData containsString:@"duola://"]) {
                            [self handleOpenURL:[NSURL URLWithString:pushData]];
                        }
                    }
                }
            }
        }
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

-(void)onReq:(BaseReq*)req {
    
}

-(void)onResp:(BaseResp*)resp {
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

#pragma mark - Rong Cloud delegate

- (void)doRCIMConnect:(NSString *)imToken tryTime:(NSInteger)time {
    // 快速集成第二步，连接融云服务器
    [[RCIM sharedRCIM] connectWithToken:imToken success:^(NSString *userId) {
        // Connect 成功
        NSLog(@"RCIM connect success, uid:%@", userId);
        
    } error:^(RCConnectErrorCode status) {
        // Connect 失败
        NSLog(@"RCIM connect failed, status:%d", status);
        
    } tokenIncorrect:^{
        // Token 失效的状态处理
        NSLog(@"RCIM connect failed, token incorrect");
        
        if (time > 0) {
            // 刷新token
            [[HttpService defaultService] POST:URL_APPEND_PATH(@"/im/token") parameters:nil JSONModelClass:[IMTokenModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                IMTokenModel *model = responseObject;
                [AccountService defaultService].account.imToken = model.data;
                [self doRCIMConnect:model.data tryTime:(time - 1)];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"refresh imtoken failed");
            }];
        }
    }];
}

// 获取用户信息的方法。
-(void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion
{
    if (!imUserDic) {
        imUserDic = [NSMutableDictionary new];
    }
    
    User *user = [imUserDic objectForKey:userId];
    if (user) {
        RCUserInfo *ui = [[RCUserInfo alloc]init];
        ui.userId = [user.uid stringValue];
        ui.name = user.nickName;
        ui.portraitUri = user.avatar;
        return completion(ui);
        
    } else {
        [[HttpService defaultService] GET:URL_APPEND_PATH(@"/im/user") parameters:@{@"uid":userId} cacheType:CacheTypeDisable JSONModelClass:[IMUserModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            IMUserModel *model = responseObject;
            
            RCUserInfo *user = [[RCUserInfo alloc]init];
            user.userId = [model.data.uid stringValue];
            user.name = model.data.nickName;
            user.portraitUri = model.data.avatar;
            
            [imUserDic setObject:user forKey:model.data];
            
            return completion(user);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    }
    
    return completion(nil);
}

// 获取群组信息的方法。
-(void)getGroupInfoWithGroupId:(NSString*)groupId completion:(void (^)(RCGroup *group))completion
{
    if (!imGroupDic) {
        imGroupDic = [NSMutableDictionary new];
    }
    
    IMGroup *group = [imGroupDic objectForKey:groupId];
    if (group) {
        RCGroup *rcg = [[RCGroup alloc]init];
        rcg.groupId = [group.groupId stringValue];
        rcg.groupName = group.groupName;
        return completion(rcg);
        
    } else {
        [[HttpService defaultService] GET:URL_APPEND_PATH(@"/im/group") parameters:@{@"id":groupId} cacheType:CacheTypeDisable JSONModelClass:[IMGroupModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            IMGroupModel *model = responseObject;
            
            RCGroup *group = [[RCGroup alloc]init];
            group.groupId = [model.data.groupId stringValue];
            group.groupName = model.data.groupName;
            
            [imGroupDic setObject:model.data forKey:groupId];
            
            return completion(group);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
    
    return completion(nil);
}

-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"onMineDotChanged" object:nil];
}

@end
