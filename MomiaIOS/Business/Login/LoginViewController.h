//
//  LoginViewController.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/25.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOGroupStyleTableViewController.h"
#import "Account.h"

typedef void (^BlockLoginSuccess)();
typedef void (^BlockLoginFail)(NSInteger code, NSString* message);
typedef void (^BlockLoginCancel)();

@interface LoginViewController : MOGroupStyleTableViewController

@property (nonatomic, strong) BlockLoginSuccess loginSuccessBlock;
@property (nonatomic, strong) BlockLoginFail loginFailBlock;
@property (nonatomic, strong) BlockLoginCancel loginCancelBlock;

@property (weak, nonatomic) UIButton *loginButton;

@end
