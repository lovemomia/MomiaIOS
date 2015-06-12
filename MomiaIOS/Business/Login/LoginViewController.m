//
//  LoginViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/25.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "AccountModel.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"登录";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(onCancelClicked)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStyleDone target:self action:@selector(onRegisterClicked)];
}

- (void)onCancelClicked {
    self.loginCancelBlock();
}

- (void)onRegisterClicked {
     RegisterViewController *viewController = [[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
    
    viewController.registerSuccessBlock = ^(){
        self.loginSuccessBlock();
    };
    [self.navigationController pushViewController:viewController animated:YES];
    
//    [self openURL:@"tq://register" byNav:self.navigationController];
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

- (IBAction)onLoginClicked:(id)sender {
    if (self.phoneTextField.text.length == 0) {
        [self showDialogWithTitle:nil message:@"手机号不能为空"];
        return;
    }
    
    if (self.passwordTextField.text.length == 0) {
        [self showDialogWithTitle:nil message:@"密码不能为空"];
        return;
    }
    
    [self login];
}

- (void)login {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *params = @{@"logintype":@"0", @"phone":self.phoneTextField.text,
                             @"password":self.passwordTextField.text};
    [[HttpService defaultService]POST:URL_APPEND_PATH(@"/auth/login")
                          parameters:params
                      JSONModelClass:[AccountModel class]
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 [MBProgressHUD hideHUDForView:self.view animated:NO];
                                 AccountModel *result = responseObject;
                                 [AccountService defaultService].account = result.data;
                                 self.loginSuccessBlock();
                             }
                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                                 [self showDialogWithTitle:nil message:error.message];
                             }];
}

@end
