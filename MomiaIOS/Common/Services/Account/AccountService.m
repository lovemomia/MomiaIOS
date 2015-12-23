//
//  AccountService.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/25.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "AccountService.h"
#import "LoginViewController.h"
#import "MONavigationController.h"
#import <RongIMKit/RongIMKit.h>

@interface AccountService()
@property (nonatomic, strong) NSMutableArray *listeners;
@end

@implementation AccountService
@synthesize account = _account;


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

- (Account *)account {
    if (_account == nil) {
        Account *ac;
        NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
        if (myEncodedObject == nil) {
            return nil;
        }
        
        ac = [NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
        _account = ac;
    }
    return _account;
}

- (void)setAccount:(Account *)account {
    if (account == nil) {
        NSUserDefaults *myDefault =[NSUserDefaults standardUserDefaults];
        [myDefault removeObjectForKey:@"account"];
        
    } else {
        account.token = self.account.token;
        [account save];
    }
    _account = account;
    if (self.listeners) {
        for (id<AccountChangeListener> listener in self.listeners) {
            [listener onAccountChange];
        }
    }
}

- (void)login:(UIViewController *)currentController success:(BlockLoginSuccess)success {
    LoginViewController *controller = [[LoginViewController alloc]initWithParams:nil];
    
    controller.loginSuccessBlock = ^(){
        [currentController dismissViewControllerAnimated:YES completion:nil];
        if (success) {
            success();
        }
        
        // 快速集成第二步，连接融云服务器
        [[RCIM sharedRCIM] connectWithToken:self.account.imToken success:^(NSString *userId) {
            // Connect 成功
            NSLog(@"RCIM connect success, uid:%@", userId);
            
        } error:^(RCConnectErrorCode status) {
            // Connect 失败
            NSLog(@"RCIM connect failed, status:%ld", status);
            
        } tokenIncorrect:^{
            // Token 失效的状态处理
            NSLog(@"RCIM connect failed, token incorrect");
        }];
    };
    controller.loginFailBlock = ^(NSInteger code, NSString* message){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    };
    controller.loginCancelBlock = ^(){
        [currentController dismissViewControllerAnimated:YES completion:nil];
    };
    
    MONavigationController *navController = [[MONavigationController alloc]initWithRootViewController:controller];
    [currentController presentViewController:navController animated:YES completion:nil];
}

- (void)logout:(UIViewController *)controller {
    self.account = nil;
    if (controller) {
        [controller.navigationController popToRootViewControllerAnimated:YES];
    }
    [[RCIM sharedRCIM] logout];
}

- (void)addListener:(id<AccountChangeListener>)listener {
    if (self.listeners == nil) {
        self.listeners = [[NSMutableArray alloc]init];
    }
    [self.listeners addObject:listener];
}

- (void)removeListener:(id<AccountChangeListener>)listener {
    if (self.listeners) {
        [self.listeners removeObject:listener];
    }
}

@end
