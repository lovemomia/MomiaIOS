//
//  ForgetPasswordViewController.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/13.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOGroupStyleTableViewController.h"

typedef void (^BlockResetPasswordSuccess)();

@interface ForgetPasswordViewController : MOGroupStyleTableViewController

@property (nonatomic, strong) BlockResetPasswordSuccess resetPasswordSuccessBlock;

@end
