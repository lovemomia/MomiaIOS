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
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *params = @{@"phone":self.phoneTextField.text, @"code":self.vercodeTextField.text};
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
        button.height = 45;
        button.width = SCREEN_WIDTH - 2 * 18;
        button.left = 18;
        button.top = 30;
        [button setTitle:@"注册" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onRigisterButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button.layer setCornerRadius:5];
        [button setBackgroundColor:MO_APP_ThemeColor];
        [view addSubview:button];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView] - 1) {
        return 80;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"RegisterCell" owner:self options:nil];
            cell = [arr objectAtIndex:0];
            
            
        } else if (indexPath.row == 1) {
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"RegisterCell" owner:self options:nil];
            cell = [arr objectAtIndex:1];
            self.phoneTextField = (UITextField *)[cell.contentView viewWithTag:1];
            
        } else if (indexPath.row == 2) {
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"RegisterCell" owner:self options:nil];
            cell = [arr objectAtIndex:2];
            self.vercodeTextField = (UITextField *)[cell.contentView viewWithTag:1];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

@end
