//
//  RegisterViewController.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/26.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOGroupStyleTableViewController.h"

typedef void (^BlockRegisterSuccess)();

@interface RegisterViewController : MOGroupStyleTableViewController

@property (nonatomic, strong) BlockRegisterSuccess registerSuccessBlock;


- (void)onVercodeButtonClicked:(id)sender;

- (void)onRigisterButtonClicked:(id)sender;

@end
