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
#import "UIImage+Color.h"
#import "NSTimer+Block.h"
#import "ForgetPasswordViewController.h"

@interface LoginViewController ()

@property(nonatomic, strong)NSString *phone;
@property(nonatomic, strong)NSString *vercode;

@property (nonatomic, assign) int secondsCountDown;
@property (nonatomic, assign) NSTimer *timer;

@property (nonatomic, strong)UIButton *vercodeButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"登录";
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStyleDone target:self action:@selector(onCancelClicked)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    [leftBtn setImage:[UIImage imageNamed:@"TitleCancel"]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStyleDone target:self action:@selector(onRegisterClicked)];
}

- (void)onCancelClicked {
    if(self.loginCancelBlock) {
        self.loginCancelBlock();
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)onRegisterClicked {
     RegisterViewController *viewController = [[RegisterViewController alloc]initWithParams:nil];
    
    viewController.registerSuccessBlock = ^(){
        if(self.loginSuccessBlock) {
            self.loginSuccessBlock();
        } else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    };
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)onForgetPasswordClicked {
    ForgetPasswordViewController *viewController = [[ForgetPasswordViewController alloc]initWithParams:nil];
    
    viewController.resetPasswordSuccessBlock = ^(){
        if(self.loginSuccessBlock) {
            self.loginSuccessBlock();
        } else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    };
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)onVercodeClicked:(id)sender {
    self.vercodeButton = sender;
    
    if (self.phone.length == 0) {
        [self showDialogWithTitle:nil message:@"手机号不能为空"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *params = @{@"mobile":self.phone, @"type":@"login"};
    [[HttpService defaultService]POST:URL_APPEND_PATH(@"/auth/send")
                           parameters:params JSONModelClass:[BaseModel class]
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod) userInfo:nil repeats:YES];
                                  self.secondsCountDown = 60;
                                  [self.vercodeButton setTitle:@"60s" forState:UIControlStateNormal];
                                  self.vercodeButton.enabled = NO;
                              }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  [self showDialogWithTitle:nil message:error.message];
                              }];
}

- (void)timerFireMethod {
    self.secondsCountDown--;
    if (self.secondsCountDown > 0) {
        [self.vercodeButton setTitle:[NSString stringWithFormat:@"%ds", self.secondsCountDown] forState:UIControlStateNormal];
        self.vercodeButton.enabled = NO;
        
    } else {
        [self.timer invalidate];
        self.vercodeButton.enabled = YES;
        [self.vercodeButton setTitle:@"获取" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onLoginClicked {
    if (self.phone.length == 0) {
        [self showDialogWithTitle:nil message:@"手机号不能为空"];
        return;
    }

    if (self.vercode.length == 0) {
        [self showDialogWithTitle:nil message:@"密码不能为空"];
        return;
    }
    
    [self login];
}

- (void)login {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *params = @{@"mobile":self.phone, @"password":self.vercode};
    [[HttpService defaultService]POST:URL_APPEND_PATH(@"/auth/login")
                          parameters:params
                      JSONModelClass:[AccountModel class]
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 [MBProgressHUD hideHUDForView:self.view animated:NO];
                                 AccountModel *result = responseObject;
                                 [AccountService defaultService].account = result.data;
                                 if(self.loginSuccessBlock) {
                                     self.loginSuccessBlock();
                                 } else {
                                     [self.navigationController popToRootViewControllerAnimated:YES];
                                 }
                             }
                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                                 [self showDialogWithTitle:nil message:error.message];
                             }];
}

#pragma mark - tableview delegate & datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    
    UIButton *forgetPwBtn = [[UIButton alloc]init];
    forgetPwBtn.height = 20;
    forgetPwBtn.width = 80;
    [forgetPwBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    forgetPwBtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    forgetPwBtn.left = SCREEN_WIDTH - 80;
    forgetPwBtn.top = 15;
    forgetPwBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [forgetPwBtn setTitleColor:MO_APP_ThemeColor forState:UIControlStateNormal];
    [forgetPwBtn addTarget:self action:@selector(onForgetPasswordClicked) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:forgetPwBtn];
    
    UIButton *button = [[UIButton alloc]init];
    button.height = 40;
    button.width = 280;
    button.left = (SCREEN_WIDTH - button.width) / 2;
    button.top = 60;
    [button setTitle:@"登录" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onLoginClicked) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"BgLargeButtonNormal"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"BgLargeButtonDisable"] forState:UIControlStateDisabled];
    [view addSubview:button];
    self.loginButton = button;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 110;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    static NSString *CellPhone = @"CellPhone";
    static NSString *CellVercode = @"CellVercode";
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellPhone];
        if (cell == nil) {
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"LoginCell" owner:self options:nil];
            cell = [arr objectAtIndex:0];
        }

        UITextField *textField = (UITextField *)[cell viewWithTag:1001];
        [textField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        
    } else if (indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellVercode];
        if (cell == nil) {
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"LoginCell" owner:self options:nil];
            cell = [arr objectAtIndex:1];
//            self.vercodeButton = (UIButton *)[cell viewWithTag:1003];
//            [self.vercodeButton addTarget:self action:@selector(onVercodeClicked:) forControlEvents:UIControlEventTouchUpInside];
//            [self.vercodeButton setBackgroundImage:[UIImage imageNamed:@"BgSmallButtonNormal"] forState:UIControlStateNormal];
//            [self.vercodeButton setBackgroundImage:[UIImage imageNamed:@"BgSmallButtonDisable"] forState:UIControlStateDisabled];
        }
        UITextField *textField = (UITextField *)[cell viewWithTag:1002];
        [textField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)textFieldWithText:(UITextField *)textField
{
    if (textField.tag == 1001) {
        self.phone = textField.text;
    } else if (textField.tag == 1002) {
        self.vercode = textField.text;
    }
}

@end
