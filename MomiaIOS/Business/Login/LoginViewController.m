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

@interface LoginViewController ()

@property(nonatomic, strong)NSString *phone;
@property(nonatomic, strong)NSString *vercode;

@property (nonatomic, assign) int secondsCountDown;
@property (nonatomic, assign) NSTimer *timer;

@property (strong, nonatomic) UIButton *vercodeButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"登录";
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStyleDone target:self action:@selector(onCancelClicked)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    [leftBtn setImage:[UIImage imageNamed:@"cm_cancel"]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStyleDone target:self action:@selector(onRegisterClicked)];
}

- (void)onCancelClicked {
    self.loginCancelBlock();
}

- (void)onRegisterClicked {
     RegisterViewController *viewController = [[RegisterViewController alloc]initWithParams:nil];
    
    viewController.registerSuccessBlock = ^(){
        self.loginSuccessBlock();
    };
    [self.navigationController pushViewController:viewController animated:YES];
    
//    [self openURL:@"tq://register" byNav:self.navigationController];
}

- (void)onVercodeButtonClicked:(id)sender {
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



- (void)onLoginClicked {
    if (self.phone.length == 0) {
        [self showDialogWithTitle:nil message:@"手机号不能为空"];
        return;
    }

    if (self.vercode.length == 0) {
        [self showDialogWithTitle:nil message:@"验证码不能为空"];
        return;
    }
    
    [self login];
}

- (void)login {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *params = @{@"mobile":self.phone, @"code":self.vercode};
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
    UIButton *button = [[UIButton alloc]init];
    button.height = 45;
    button.width = SCREEN_WIDTH - 2 * 18;
    button.left = 18;
    button.top = 30;
    [button setTitle:@"登录" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onLoginClicked) forControlEvents:UIControlEventTouchUpInside];
    [button.layer setCornerRadius:5];
    [button setBackgroundColor:MO_APP_ThemeColor];
    [view addSubview:button];
    self.loginButton = button;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 80;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        static NSString *identifier = @"CellPhone";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"LoginCell" owner:self options:nil];
            cell = [arr objectAtIndex:0];
        }

        UITextField *textField = (UITextField *)[cell viewWithTag:1001];
        [textField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        
    } else if (indexPath.row == 1) {
        static NSString *identifier = @"CellVercode";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"LoginCell" owner:self options:nil];
            cell = [arr objectAtIndex:1];
        }
        UITextField *textField = (UITextField *)[cell viewWithTag:1002];
        [textField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        self.vercodeButton = (UIButton *)[cell viewWithTag:1003];
        [self.vercodeButton addTarget:self action:@selector(onVercodeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
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
