//
//  RNCommon.m
//  MomiaIOS
//
//  Created by Deng Jun on 16/5/16.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "RNCommon.h"
#import "CityManager.h"
#import "NSString+MOEncrypt.h"
#import "AppDelegate.h"

@implementation RNCommon

RCT_EXPORT_MODULE();

//Base
RCT_EXPORT_METHOD(dismissViewControllerAnimated:(BOOL)flag)
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.root dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"dismissViewControllerAnimated");
}

//设置当前选择城市
RCT_EXPORT_METHOD(setChoosedCity:(NSDictionary *)city)
{
    [CityManager shareManager].choosedCity = [[City alloc]initWithDictionary:city error:nil];
}

//签名
RCT_EXPORT_METHOD(signRequestParams:(NSDictionary *)params callback:(RCTResponseSenderBlock)callback)
{
    NSString *result = @"";
    if ([params count] > 0) {
        
        NSMutableArray *allKeys = [[NSMutableArray alloc] initWithArray:[params allKeys]];
        [allKeys sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            return [obj1 compare:obj2];
        }];
        
        NSMutableString *sysSign = [[NSMutableString alloc] initWithCapacity:50];
        [allKeys enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            NSObject *value = [params objectForKey:obj];
            if ([value isKindOfClass:[NSString class]] && ((NSString *)value).length == 0) {
                // do nothing;
            } else {
                [sysSign appendString:[NSString stringWithFormat:@"%@=%@", obj, [params objectForKey:obj]]];
            }
        }];
        
        // 固定字符加密
        [sysSign appendString:@"key=578890d82212ae548d883bc7a201cdf4"];
        
        if ([sysSign length] > 0) {
            NSString *md5 = [sysSign md5];
            if (md5 != nil) {
                result = md5;
            }
        }
    }
    
    callback(@[[NSNull null], result]);
}

+ (RCTRootView *)createRCTViewWithBundleURL:(NSURL *)bundleURL
                                 moduleName:(NSString *)moduleName
                          initialProperties:(NSDictionary *)initialProperties
                              launchOptions:(NSDictionary *)launchOptions {
    NSMutableDictionary *dic;
    if (initialProperties) {
        dic = [[NSMutableDictionary alloc]initWithDictionary:initialProperties];
    } else {
        dic = [[NSMutableDictionary alloc]init];
    }
    
    // add basic params
    // 用户token
    if ([[AccountService defaultService] isLogin]) {
        [dic setObject:[AccountService defaultService].account.token forKey:@"_utoken"];
    }
    // app版本
    [dic setObject:MO_APP_VERSION forKey:@"_v"];
    // 终端类型
    [dic setObject:@"iphone" forKey:@"_terminal"];
    // 系统版本号
    [dic setObject:[NSString stringWithFormat:@"%f", MO_OS_VERSION] forKey:@"_os"];
    // 设备型号，iphone6
    [dic setObject:[UIDevice currentDevice].model forKey:@"_device"];
    // 渠道号
    [dic setObject:@"appstore" forKey:@"_channel"];
    // 网络类型
    [dic setObject:[Environment singleton].networkType forKey:@"_net"];
    // cityid
    [dic setObject:[NSString stringWithFormat:@"%@", [CityManager shareManager].choosedCity.ids] forKey:@"_city"];
    
    RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:bundleURL moduleName: moduleName initialProperties:dic launchOptions:nil];
    return rootView;
}


@end
