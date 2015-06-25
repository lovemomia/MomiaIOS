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

@property (weak, nonatomic) UITextField *phoneTextField;
@property (weak, nonatomic) UITextField *vercodeTextField;
@property (weak, nonatomic) UIButton *vercodeButton;


- (IBAction)onVercodeButtonClicked:(id)sender;

- (IBAction)onRigisterButtonClicked:(id)sender;

@end
