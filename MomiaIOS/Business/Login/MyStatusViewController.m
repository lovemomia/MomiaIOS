//
//  MyStatusViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/26.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MyStatusViewController.h"
#import "DatePickerSheet.h"
#import "AccountModel.h"

@interface Baby : NSObject
@property (nonatomic, strong) NSNumber *ids;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *birthday;
@end
@implementation Baby
@end

@interface MyStatusViewController () <DatePickerSheetDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) NSMutableArray *babys;

@end

@implementation MyStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"添加孩子信息";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(onAddChildClicked)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"cm_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)] style:UIBarButtonItemStylePlain target:self action:@selector(onBackClicked)];
    
    self.babys = [NSMutableArray new];
    [self.babys addObject:[Baby new]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewStyle)tableViewStyle {
    return UITableViewStyleGrouped;
}

- (UITableViewCellSeparatorStyle)tableViewCellSeparatorStyle {
    return UITableViewCellSeparatorStyleSingleLine;
}

- (void)onBackClicked {
    self.operateSuccessBlock();
}

- (void)onAddChildClicked {
    
}

- (void)onFinishClicked {
    if ([self check]) {
        
    }
    self.operateSuccessBlock();
}

- (BOOL)check {
    
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellDefault"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellDefault"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSInteger row = indexPath.row;
    if (row == 0) {
        cell.textLabel.text = @"姓名";
        
    } else if (row == 1) {
        cell.textLabel.text = @"性别";
        cell.detailTextLabel.text = @"";
        
    } else {
        cell.textLabel.text = @"生日";
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    if (section == [self numberOfSectionsInTableView:tableView] - 1) {
        UIButton *logoutButton = [[UIButton alloc]init];
        logoutButton.height = 45;
        logoutButton.width = SCREEN_WIDTH - 2 * 18;
        logoutButton.left = 18;
        logoutButton.top = 20;
        [logoutButton setTitle:@"完成" forState:UIControlStateNormal];
        [logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [logoutButton addTarget:self action:@selector(onFinishClicked) forControlEvents:UIControlEventTouchUpInside];
        [logoutButton.layer setCornerRadius:5];
        [logoutButton setBackgroundColor:MO_APP_ThemeColor];
        [view addSubview:logoutButton];
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self updateBabyDate:nil];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"修改姓名" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认修改", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        alert.tag = indexPath.section;
        [alert show];
        
    } else if (indexPath.row == 1) {
        [self showSexPicker:indexPath.section];
        
    } else {
        [self showDatePicker:indexPath.section];
    }
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) { //修改宝宝姓名
        //得到输入框
        UITextField *tf=[alertView textFieldAtIndex:0];
        ((Baby *)[self.babys objectAtIndex:alertView.tag]).name = tf.text;
    }
}

- (void)updateBabyDate:(NSString *)date {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *params = @{@"babydate" : (date == nil ? @"":date)};
    [[HttpService defaultService]POST:URL_APPEND_PATH(@"/user/babydate")
                           parameters:params JSONModelClass:[AccountModel class]
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  self.operateSuccessBlock();
                                  AccountModel *result = (AccountModel *)responseObject;
                                  [AccountService defaultService].account = result.data;
                              }
     
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  [self showDialogWithTitle:nil message:error.message];
                              }];
}

#pragma mark - sex picker

-(void)showSexPicker:(int)child {
    UIActionSheet *sexSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"男",@"女",nil];
    sexSheet.tag = child;
    [sexSheet showInView:[[UIApplication sharedApplication].delegate window]];
}

#pragma mark -
#pragma UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString * sex = buttonIndex == 0 ? @"男" : @"女";
    ((Baby *)[self.babys objectAtIndex:actionSheet.tag]).sex = sex;
}

#pragma mark - DatePickerSheetDelegate method

- (void)showDatePicker:(NSInteger)child {
    DatePickerSheet * datePickerSheet = [DatePickerSheet getInstance];
    [datePickerSheet initializationWithMaxDate:nil
                                   withMinDate:nil
                            withDatePickerMode:UIDatePickerModeDate
                                  withDelegate:self];
    datePickerSheet.tag = child;
    [datePickerSheet showDatePickerSheet];
}

- (void) datePickerSheet:(DatePickerSheet*)datePickerSheet chosenDate:(NSDate*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [formatter stringFromDate:date];
    ((Baby *)[self.babys objectAtIndex:datePickerSheet.tag]).name = dateString;
}


@end
