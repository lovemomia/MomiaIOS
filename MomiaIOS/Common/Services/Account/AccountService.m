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
        Account *ac =[[Account alloc]init];
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
        [account save];
    }
    _account = account;
}

- (void)login:(UIViewController *)currentController {
    LoginViewController *controller = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    
    controller.loginSuccessBlock = ^(){
        [currentController dismissViewControllerAnimated:NO completion:nil];
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

@end
