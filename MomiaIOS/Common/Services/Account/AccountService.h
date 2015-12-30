//
//  AccountService.h
//  MomiaIOS
//
//  账户服务，提供登录、注册相关接口
//
//  Created by Deng Jun on 15/5/25.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"

typedef void (^BlockLoginSuccess)();

@protocol AccountChangeListener<NSObject>

- (void)onAccountChange;

@end

@interface AccountService : NSObject

@property (nonatomic, strong) Account *account;

/**
 *  获取account服务单例
 */
+ (instancetype)defaultService;

/**
 *  是否登录
 */
- (BOOL)isLogin;

- (void)login:(UIViewController *)currentController success:(BlockLoginSuccess)success;

- (void)logout:(UIViewController *)controller;

- (void)addListener:(id<AccountChangeListener>)listener;

- (void)removeListener:(id<AccountChangeListener>)listener;

@end
