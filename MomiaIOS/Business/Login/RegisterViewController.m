//
//  RegisterViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/26.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "RegisterViewController.h"
#import "BaseModel.h"
#import "AccountModel.h"
#import "MyStatusViewController.h"

@interface RegisterViewController ()

@property (nonatomic, assign) int secondsCountDown;
@property (nonatomic, assign) NSTimer *timer;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"注册";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onVercodeButtonClicked:(id)sender {
    if (self.phoneTextField.text.length == 0) {
        [self showDialogWithTitle:nil message:@"手机号不能为空"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *params = @{@"phone":self.phoneTextField.text};
    [[HttpService defaultService]POST:URL_APPEND_PATH(@"/sms/send")
                           parameters:params JSONModelClass:[BaseModel class]
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod) userInfo:nil repeats:YES];
                                  
                                  self.secondsCountDown = 60;
                                  [self.vercodeButton setTitle:@"60s" forState:UIControlStateNormal];
                                  self.vercodeButton.enabled = false;
                                  
                              }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  [self showDialogWithTitle:nil message:error.message];
                              }];
}

- (void)timerFireMethod {
    self.secondsCountDown--;
    [self.vercodeButton setTitle:[NSString stringWithFormat:@"%ds", self.secondsCountDown] forState:UIControlStateNormal];
    if (self.secondsCountDown == 0) {
        [self.timer invalidate];
        [self.vercodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        self.vercodeButton.enabled = true;
    }
}

- (IBAction)onRigisterButtonClicked:(id)sender {
    if (self.phoneTextField.text.length == 0) {
        [self showDialogWithTitle:nil message:@"手机号不能为空"];
        return;
    }
    
    if (self.vercodeTextField.text.length == 0) {
        [self showDialogWithTitle:nil message:@"验证码不能为空"];
        return;
    }
    
    if (self.passwordTextField.text.length == 0) {
        [self showDialogWithTitle:nil message:@"密码不能为空"];
        return;
    }
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *params = @{@"phone":self.phoneTextField.text, @"code":self.vercodeTextField.text, @"password":self.passwordTextField.text};
    [[HttpService defaultService]POST:URL_APPEND_PATH(@"/auth/register")
                           parameters:params JSONModelClass:[AccountModel class]
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  
                                  AccountModel *result = responseObject;
                                  [AccountService defaultService].account = result.data;
                                  
                                  //前往选择我的状态页面
                                  MyStatusViewController *controller = [[MyStatusViewController alloc]init];
                                  
                                  controller.operateSuccessBlock = ^(){
                                      self.registerSuccessBlock();
                                  };
                                  
                                  [self.navigationController pushViewController:controller animated:YES];
                              }
     
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  [self showDialogWithTitle:nil message:error.message];
                              }];
}

@end
