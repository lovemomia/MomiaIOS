//
//  AccountService.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/25.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "AccountService.h"

@implementation AccountService

+ (instancetype)defaultService {
    static AccountService *__service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __service = [[self alloc] init];
    });
    return __service;
}

- (BOOL)isLogin {
    return self.account == nil ? NO : YES;
}

@end
