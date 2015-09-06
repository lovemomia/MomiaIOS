//
//  ForgetPasswordViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/13.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "AccountModel.h"

@interface ForgetPasswordViewController ()

@property (nonatomic, assign) int secondsCountDown;
@property (nonatomic, assign) NSTimer *timer;

@property(nonatomic, strong) NSString *password;
@property(nonatomic, strong) NSString *phone;
@property(nonatomic, strong) NSString *vercode;

@property (nonatomic, strong) UIButton *vercodeButton;

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"重置密码";
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

- (void)onVercodeClicked:(id)sender {
    self.vercodeButton = sender;
    
    if (self.phone.length == 0) {
        [self showDialogWithTitle:nil message:@"手机号不能为空"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *params = @{@"mobile":self.phone};
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

- (void)onOKButtonClicked:(id)sender {
    if (self.phone.length == 0) {
        [self showDialogWithTitle:nil message:@"手机号不能为空"];
        return;
    }
    
    if (self.password.length == 0) {
        [self showDialogWithTitle:nil message:@"密码不能为空"];
        return;
    }
    
    if (self.vercode.length == 0) {
        [self showDialogWithTitle:nil message:@"验证码不能为空"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *params = @{@"password":self.password, @"mobile":self.phone, @"code":self.vercode};
    [[HttpService defaultService]POST:URL_APPEND_PATH(@"/auth/password")
                           parameters:params JSONModelClass:[AccountModel class]
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  
                                  AccountModel *result = responseObject;
                                  [AccountService defaultService].account = result.data;
                                  
                                  self.resetPasswordSuccessBlock();
                              }
     
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  [self showDialogWithTitle:nil message:error.message];
                              }];
}

#pragma mark - tableview delegate & datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView] - 1) {
        UIView *view = [UIView new];
        UIButton *button = [[UIButton alloc]init];
        button.height = 40;
        button.width = 280;
        button.left = (SCREEN_WIDTH - button.width) / 2;
        button.top = 30;
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onOKButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:@"BgLargeButtonNormal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"BgLargeButtonDisable"] forState:UIControlStateDisabled];
        [view addSubview:button];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView] - 1) {
        return 80;
    }
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"ForgetPasswordCell" owner:self options:nil];
            cell = [arr objectAtIndex:0];
            
            UITextField *textField = (UITextField *)[cell viewWithTag:1001];
            [textField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
            
        }  else if (indexPath.row == 1) {
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"ForgetPasswordCell" owner:self options:nil];
            cell = [arr objectAtIndex:1];
            
            UITextField *textField = (UITextField *)[cell viewWithTag:1002];
            [textField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
            
        } else if (indexPath.row == 2) {
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"ForgetPasswordCell" owner:self options:nil];
            cell = [arr objectAtIndex:2];
            
            UITextField *textField = (UITextField *)[cell viewWithTag:1004];
            [textField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
            
            self.vercodeButton = (UIButton *)[cell viewWithTag:1005];
            [self.vercodeButton addTarget:self action:@selector(onVercodeClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.vercodeButton setBackgroundImage:[UIImage imageNamed:@"BgSmallButtonNormal"] forState:UIControlStateNormal];
            [self.vercodeButton setBackgroundImage:[UIImage imageNamed:@"BgSmallButtonDisable"] forState:UIControlStateDisabled];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)textFieldWithText:(UITextField *)textField
{
    if (textField.tag == 1001) {
        self.phone = textField.text;
    } else if (textField.tag == 1002) {
        self.password = textField.text;
    } else if (textField.tag == 1004) {
        self.vercode = textField.text;
    }
}


@end
