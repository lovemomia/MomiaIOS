//
//  LocationService.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/6/25.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "LocationService.h"

@implementation LocationService

+ (instancetype)defaultService {
    static LocationService *__service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __service = [[self alloc] init];
    });
    return __service;
}

@end
