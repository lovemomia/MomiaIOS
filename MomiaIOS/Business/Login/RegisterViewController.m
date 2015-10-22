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
#import "UIButton+Block.h"
#import "NSString+MOURLEncode.h"
#import "ActivityWebViewController.h"

@interface RegisterViewController ()

@property (nonatomic, assign) int secondsCountDown;
@property (nonatomic, assign) NSTimer *timer;

@property(nonatomic, strong)NSString *nickName;
@property(nonatomic, strong)NSString *password;
@property(nonatomic, strong)NSString *phone;
@property(nonatomic, strong)NSString *vercode;
@property(nonatomic, assign)BOOL agree;

@property (nonatomic, strong)UIButton *vercodeButton;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"注册";
    self.agree = YES;
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
    NSDictionary *params = @{@"mobile":self.phone, @"type":@"register"};
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

- (void)onRigisterButtonClicked:(id)sender {
    if (self.nickName.length == 0) {
        [self showDialogWithTitle:nil message:@"昵称不能为空"];
        return;
    }
    
    if (self.password.length == 0) {
        [self showDialogWithTitle:nil message:@"密码不能为空"];
        return;
    }
    
    if (self.phone.length == 0) {
        [self showDialogWithTitle:nil message:@"手机号不能为空"];
        return;
    }
    
    if (self.vercode.length == 0) {
        [self showDialogWithTitle:nil message:@"验证码不能为空"];
        return;
    }
    
    if (self.agree == NO) {
        [self showDialogWithTitle:nil message:@"您必须同意松果亲子用户服务协议才能进行下一步操作"];
        return;
    }
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *params = @{@"nickname":self.nickName, @"password":self.password, @"mobile":self.phone, @"code":self.vercode};
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

#pragma mark - tableview delegate & datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView] - 1) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"RegisterCell" owner:self options:nil];
        UIView *footer = [arr objectAtIndex:4];
        
        UIButton *button = (UIButton *)[footer viewWithTag:1001];
        [button addTarget:self action:@selector(onRigisterButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:@"BgLargeButtonNormal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"BgLargeButtonDisable"] forState:UIControlStateDisabled];

        UIButton *agreeBtn = (UIButton *)[footer viewWithTag:1002];
        [agreeBtn addAction:^(UIButton *btn) {
            self.agree = !self.agree;
            if (self.agree) {
                [btn setBackgroundImage:[UIImage imageNamed:@"IconAgreeChecked"]];
            } else {
                [btn setBackgroundImage:[UIImage imageNamed:@"IconAgreeUncheck"]];
            }
        }];
        if (self.agree) {
            [agreeBtn setBackgroundImage:[UIImage imageNamed:@"IconAgreeChecked"]];
        } else {
            [agreeBtn setBackgroundImage:[UIImage imageNamed:@"IconAgreeUncheck"]];
        }
        
        UIButton *agreement = (UIButton *)[footer viewWithTag:1003];
        [agreement addAction:^(UIButton *btn) {
            ActivityWebViewController *web = [[ActivityWebViewController alloc]initWithParams:@{@"url":[@"http://www.sogokids.com/agreement.html" URLEncodedString]}];
            [self.navigationController pushViewController:web animated:YES];
            
        }];
        return footer;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView] - 1) {
        return 120;
    }
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"RegisterCell" owner:self options:nil];
            cell = [arr objectAtIndex:0];
            
            UITextField *textField = (UITextField *)[cell viewWithTag:1001];
            [textField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
            
        }  else if (indexPath.row == 1) {
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"RegisterCell" owner:self options:nil];
            cell = [arr objectAtIndex:1];
            
            UITextField *textField = (UITextField *)[cell viewWithTag:1002];
            [textField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
            
        } else if (indexPath.row == 2) {
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"RegisterCell" owner:self options:nil];
            cell = [arr objectAtIndex:2];
            
            UITextField *textField = (UITextField *)[cell viewWithTag:1003];
            [textField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
            
        } else if (indexPath.row == 3) {
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"RegisterCell" owner:self options:nil];
            cell = [arr objectAtIndex:3];
            
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
        self.nickName = textField.text;
    } else if (textField.tag == 1002) {
        self.password = textField.text;
    } else if (textField.tag == 1003) {
        self.phone = textField.text;
    } else if (textField.tag == 1004) {
        self.vercode = textField.text;
    }
}

@end
