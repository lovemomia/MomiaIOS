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

#pragma mark -
#pragma mark 页面操作相关

RCT_EXPORT_METHOD(dismissViewControllerAnimated:(BOOL)flag)
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.root dismissViewControllerAnimated:YES completion:nil];
}

//通过url调起页面（注意：url不要包含scheme）
RCT_EXPORT_METHOD(openUrl:(NSString *)url)
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:MOURL_STRING(url)]];
    NSLog(@"RN openUrl: %@", url);
}

//设置当前选择城市
RCT_EXPORT_METHOD(setChoosedCity:(NSDictionary *)city)
{
    [CityManager shareManager].choosedCity = [[City alloc]initWithDictionary:city error:nil];
}

RCT_EXPORT_METHOD(isLogin:(RCTResponseSenderBlock)callback)
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    NSString *isLogin = [[AccountService defaultService] isLogin] ? @"true" : @"false";
    [dic setObject:isLogin forKey:@"isLogin"];
    callback(@[[NSNull null], dic]);
}

#pragma mark -
#pragma mark  网络请求utils

//对js里面的请求参数二次封装
RCT_EXPORT_METHOD(wrapParams:(NSDictionary *)params callback:(RCTResponseSenderBlock)callback)
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    if (params) {
        [dic addEntriesFromDictionary:params];
    }
    
    // 用户token
    if ([[AccountService defaultService] isLogin]) {
        [dic setObject:[AccountService defaultService].account.token forKey:@"utoken"];
    }
    
    // app版本
    [dic setObject:MO_APP_VERSION forKey:@"v"];
    
    // 终端类型
    [dic setObject:@"iphone" forKey:@"terminal"];
    
    // 系统版本号
    [dic setObject:[NSString stringWithFormat:@"%f", MO_OS_VERSION] forKey:@"os"];
    
    // 设备型号，iphone6
    [dic setObject:[UIDevice currentDevice].model forKey:@"device"];
    
    // 渠道号
    [dic setObject:@"appstore" forKey:@"channel"];
    
    // 网络类型
    [dic setObject:[Environment singleton].networkType forKey:@"net"];
    
    // cityid
    [dic setObject:[NSString stringWithFormat:@"%@", [CityManager shareManager].choosedCity.ids] forKey:@"city"];
    
    // 签名
    NSString *sysSign = [RNCommon doSignWithParameters:dic];
    if (sysSign != nil) {
        [dic setObject:sysSign forKey:@"sign"];
    }
    
    callback(@[[NSNull null], dic]);
}

//对js里面的请求url做二次封装
RCT_EXPORT_METHOD(wrapUrl:(NSString *)urlStr callback:(RCTResponseSenderBlock)callback)
{
    NSDictionary *paramsDic = [RNCommon getParamsWithUrl:urlStr];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    if (paramsDic) {
        [dic addEntriesFromDictionary:paramsDic];
    }
    
    // 用户token
    if ([[AccountService defaultService] isLogin]) {
        [dic setObject:[AccountService defaultService].account.token forKey:@"utoken"];
    }
    
    // app版本
    [dic setObject:MO_APP_VERSION forKey:@"v"];
    
    // 终端类型
    [dic setObject:@"iphone" forKey:@"terminal"];
    
    // 系统版本号
    [dic setObject:[NSString stringWithFormat:@"%f", MO_OS_VERSION] forKey:@"os"];
    
    // 设备型号，iphone6
    [dic setObject:[UIDevice currentDevice].model forKey:@"device"];
    
    // 渠道号
    [dic setObject:@"appstore" forKey:@"channel"];
    
    // 网络类型
    [dic setObject:[Environment singleton].networkType forKey:@"net"];
    
    // cityid
    [dic setObject:[NSString stringWithFormat:@"%@", [CityManager shareManager].choosedCity.ids] forKey:@"city"];
    
    
    // 签名
    NSString *sysSign = [RNCommon doSignWithParameters:dic];
    if (sysSign != nil) {
        [dic setObject:sysSign forKey:@"sign"];
    }
    
    NSMutableString *ms = [[NSMutableString alloc]initWithString:urlStr];
    
    NSRange range = [urlStr rangeOfString:@"?"];
    if(range.length == NSNotFound) {
        [ms appendString:@"?"];
    }
    for (NSString *key in [dic keyEnumerator]) {
        NSString *value = [dic valueForKey:key];
        [ms appendString:[NSString stringWithFormat:@"&%@=%@", key, value]];
    }
    
    callback(@[[NSNull null], ms]);
}

+ (NSDictionary *)getParamsWithUrl:(NSString *)urlStr {
    if (!urlStr) {
        return nil;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:4];
    
    NSRange range = [urlStr rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return nil;
    }
    
    NSString *propertys = [urlStr substringFromIndex:(int)(range.location+1)];
    NSArray *subArray = [propertys componentsSeparatedByString:@"&"];
    
    for (int j = 0 ; j < subArray.count; j++)
    {
        NSArray *dicArray = [subArray[j] componentsSeparatedByString:@"="];
        [dic setObject:dicArray[1] forKey:dicArray[0]];
    }
    
    return dic;
}

/**
 *  URL签名
 *
 *  @param dictionary 参数字典
 *
 *  @return 请求的sign字段
 */
+ (NSString *)doSignWithParameters:(NSDictionary *)dictionary {
    
    // 签名
    if ([dictionary isKindOfClass:[NSDictionary class]] &&
        [dictionary count] > 0) {
        
        NSMutableArray *allKeys = [[NSMutableArray alloc] initWithArray:[dictionary allKeys]];
        [allKeys sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            return [obj1 compare:obj2];
        }];
        
        NSMutableString *sysSign = [[NSMutableString alloc] initWithCapacity:50];
        [allKeys enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            NSObject *value = [dictionary objectForKey:obj];
            if ([value isKindOfClass:[NSString class]] && ((NSString *)value).length == 0) {
                // do nothing;
            } else {
                [sysSign appendString:[NSString stringWithFormat:@"%@=%@", obj, [dictionary objectForKey:obj]]];
            }
        }];
        
        // 固定字符加密
        [sysSign appendString:@"key=578890d82212ae548d883bc7a201cdf4"];
        
        if ([sysSign length] > 0) {
            NSString *md5 = [sysSign md5];
            if (md5 != nil) {
                return md5;
            }
        }
    }
    
    return nil;
}

#pragma mark -
#pragma mark  构造RCTView

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
    //运行环境
    [dic setObject:MO_DEBUG ? @"1" : @"0" forKey:@"_debug"];
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
