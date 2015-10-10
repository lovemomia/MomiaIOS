//
//  SubmitLeaderViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/29.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "SubmitLeaderViewController.h"
#import "CommonHeaderView.h"

@interface SubmitLeaderViewController ()<MOTextViewDelegate,UITextFieldDelegate>

@property(nonatomic,weak) UIView * activeView;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;
//@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *job;
@property (nonatomic, strong) NSString *intro;

@property (nonatomic, strong) UITableViewCell *introCell;

@end

@implementation SubmitLeaderViewController

#pragma mark - viewController life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"成为领队";
    
    [CommonHeaderView registerCellFromNibWithTableView:self.tableView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self registerForKeyboardNotifications];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self removeForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - solve active textObject hidden by keyboard
// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)removeForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height + 20, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    
    CGRect textRect = [self.view convertRect:self.activeView.bounds fromView:self.activeView];
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    
    UITableViewCell * cell;
    UIView *view = self.activeView;
    while (view != nil && ![view isKindOfClass:[UITableViewCell class]]) {
        view = [view superview];
    }
    cell = (UITableViewCell *)view;
    
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
//    if (!CGRectContainsPoint(aRect, textRect.origin) ) {
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
}

- (void)onSubmitClick {
    if (self.name.length == 0) {
        [self showDialogWithTitle:nil message:@"名字不能为空"];
        return;
    }
    
    if (self.phone.length == 0) {
        [self showDialogWithTitle:nil message:@"手机号不能为空"];
        return;
    }
    
//    if (self.address.length == 0) {
//        [self showDialogWithTitle:nil message:@"常居地不能为空"];
//        return;
//    }
    
    if (self.job.length == 0) {
        [self showDialogWithTitle:nil message:@"职业不能为空"];
        return;
    }
    
    if (self.intro.length < 20) {
        [self showDialogWithTitle:nil message:@"个人介绍至少20个字"];
        return;
    }
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *params = @{@"name":self.name, @"mobile":self.phone, @"career":self.job, @"intro":self.intro};
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    if (!jsonData) {
        NSLog(@"fail: %@", error);
        return;
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    [[HttpService defaultService]POST:URL_APPEND_PATH(@"/leader/signup")
                           parameters:@{@"leader":jsonString} JSONModelClass:[BaseModel class]
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  
                                  [self showDialogWithTitle:nil message:@"您的申请已提交，审核通过后我们会尽快通知您" tag:1001];
                              }
     
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  [self showDialogWithTitle:nil message:error.message];
                              }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - mo delegate

- (void)moTextViewDidBeginEditing:(UITextView *)textView {
    self.activeView = textView;
}

- (void)moTextViewDidEndEditing:(UITextView *)textView {
    self.activeView = nil;
}

-(void)moTextViewDidChange:(UITextView *)textView {
    self.intro = textView.text;
}

#pragma mark - tableview delegate & datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *title;
    NSInteger tag = 0;
    NSInteger row = indexPath.row;
    if (indexPath.section == 0) {
        if (row == 0) {
            title = @"姓名";
            tag = 0;
        } else if (row == 1) {
            title = @"手机号";
            tag = 1;
        } else if (row == 2) {
            title = @"职业";
            tag = 2;
        }
    } else {
        return;
    }
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"输入%@", title] message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = tag;
    [alert show];
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if (alertView.tag == 1001) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
        }
        
    } else if (buttonIndex == 1) {
        UITextField *tf=[alertView textFieldAtIndex:0];
        if (alertView.tag == 0) {
            self.name = tf.text;
            
        } else if (alertView.tag == 1) {
            self.phone = tf.text;
        } else if (alertView.tag == 2) {
            self.job = tf.text;
        }
        [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 1) {
        return 100;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    static NSString *CellDefault = @"DefaultCell";
    UITableViewCell *cell;
    if (section == 1 && row == 1) {
        cell = [[UITableViewCell alloc] init];
        UITextView *tv = [[UITextView alloc]init];
        tv.textColor = UIColorFromRGB(0x333333);
        tv.font = [UIFont systemFontOfSize: 15.0];
        tv.placeHolderTextView.font = [UIFont systemFontOfSize: 15.0];
        tv.moDelegate = self;
        tv.tag = 1001;
        [cell.contentView addSubview:tv];
        
        [tv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell).with.offset(10);
            make.right.equalTo(cell).with.offset(-10);
            make.top.equalTo(cell).with.offset(5);
            make.bottom.equalTo(cell).with.offset(-5);
        }];
        
        if ([self.intro length] > 0) {
            tv.text = self.intro;
        } else {
            [tv addPlaceHolder:@"至少20字"];
        }
        
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:CellDefault];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellDefault];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        cell.textLabel.textColor = UIColorFromRGB(0x333333);
        cell.textLabel.font = [UIFont systemFontOfSize: 15.0];
        cell.detailTextLabel.textColor = UIColorFromRGB(0x999999);
        cell.detailTextLabel.font = [UIFont systemFontOfSize: 15.0];
        
        if (section == 0) {
            if (row == 0) {
                cell.textLabel.text = @"真实姓名";
                cell.detailTextLabel.text = self.name;
                
            } else if (row == 1) {
                cell.textLabel.text = @"手机号";
                cell.detailTextLabel.text = self.phone;
                
            } else if (row == 2) {
                cell.textLabel.text = @"职业";
                cell.detailTextLabel.text = self.job;
            }
            
        } else {
            if (row == 0) {
                cell.textLabel.text = @"个人背景介绍";
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 45;
    }
    return 10;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        CommonHeaderView *view = [CommonHeaderView cellWithTableView:self.tableView];
        view.data = @"如果您感兴趣，请花2分钟填写以下表格，我们的领队顾问将在1个工作日之内与您联系。";
        return view;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    if (section == [self numberOfSectionsInTableView:tableView] - 1) {
        UIButton *button = [[UIButton alloc]init];
        button.height = 40;
        button.width = 280;
        button.left = (SCREEN_WIDTH - button.width) / 2;
        button.top = 30;
        [button setTitle:@"提交" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onSubmitClick) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:@"BgLargeButtonNormal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"BgLargeButtonDisable"] forState:UIControlStateDisabled];
        
        [view addSubview:button];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView] - 1) {
        return 80;
    }
    return 0.1;
}

@end
