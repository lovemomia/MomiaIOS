//
//  PayTool.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/9.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "PayTool.h"

@implementation PayTool

- (void)startAlipay:(AlipayOrder *)order payResult:(BlockPayResult)callback {
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"duola";
    //将商品信息拼接成字符串
    NSString *orderString = [order description];
    if (orderString != nil) {
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            if ([[resultDic objectForKey:@"resultStatus"] integerValue] == 9000) {
                callback(YES);
            } else {
                callback(NO);
                NSLog(@"reslut = %@",resultDic);
            }
        }];
    }
}

@end
