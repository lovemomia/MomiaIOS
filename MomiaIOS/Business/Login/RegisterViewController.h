//
//  RegisterViewController.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/26.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOViewController.h"

typedef void (^BlockRegisterSuccess)();

@interface RegisterViewController : MOViewController

@property (nonatomic, strong) BlockRegisterSuccess registerSuccessBlock;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *vercodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *vercodeButton;


- (IBAction)onVercodeButtonClicked:(id)sender;

- (IBAction)onRigisterButtonClicked:(id)sender;

@end
