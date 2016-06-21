//
//  Environment.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/20.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "Environment.h"

@implementation Environment

+ (instancetype)singleton {
    static Environment *__singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __singleton = [[self alloc] init];
    });
    return __singleton;
}

- (NSString *)networkType {
    NSString *type = @"";
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    switch (reachabilityManager.networkReachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown:
            type = @"unknown";
            break;
        case AFNetworkReachabilityStatusNotReachable:
            type = @"notreachable";
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            type = @"3G";
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            type = @"wifi";
            break;
        default:
            type = @"unknown";
            break;
    }
    return type;
}

@end
