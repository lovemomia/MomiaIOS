//
//  LoginViewController.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/25.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOViewController.h"
#import "Account.h"
#import "MOButton.h"

typedef void (^BlockLoginSuccess)();
typedef void (^BlockLoginFail)(NSInteger code, NSString* message);
typedef void (^BlockLoginCancel)();

@interface LoginViewController : MOViewController

@property (nonatomic, strong) BlockLoginSuccess loginSuccessBlock;
@property (nonatomic, strong) BlockLoginFail loginFailBlock;
@property (nonatomic, strong) BlockLoginCancel loginCancelBlock;


@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet MOButton *loginButton;

- (IBAction)onLoginClicked:(id)sender;

@end
