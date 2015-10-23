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
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *birthday;
@end
@implementation Baby
- (NSMutableDictionary *)toNSDictionary
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:self.name forKey:@"name"];
    [dictionary setValue:self.sex forKey:@"sex"];
    [dictionary setValue:self.birthday forKey:@"birthday"];
    
    return dictionary;
}
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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"TitleBack"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)] style:UIBarButtonItemStylePlain target:self action:@selector(onBackClicked)];
    
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
    [self.babys addObject:[Baby new]];
    [self.tableView reloadData];
}

- (void)onFinishClicked {
    if ([self check].count > 0) {
        [self addBabysInfo];
    } else {
        self.operateSuccessBlock();
    }
}

- (NSArray *)check {
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (Baby *baby in self.babys) {
        if (baby.name.length == 0) {
            [self showDialogWithTitle:nil message:@"宝宝姓名缺失"];
            return nil;
        }
        if (baby.sex.length == 0) {
            [self showDialogWithTitle:nil message:@"宝宝性别缺失"];
            return nil;
        }
        if (baby.birthday.length == 0) {
            [self showDialogWithTitle:nil message:@"宝宝生日缺失"];
            return nil;
        }
        [array addObject:baby];
    }
    return array;
}

- (void)addBabysInfo {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableArray *babyArray = [[NSMutableArray alloc] init];
    for (Baby *baby in self.babys) {
        [babyArray addObject:[baby toNSDictionary]];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:babyArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *params = @{@"children" : jsonString};
    [[HttpService defaultService]POST:URL_APPEND_PATH(@"/user/child")
                           parameters:params JSONModelClass:[AccountModel class]
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  self.operateSuccessBlock();
                                  AccountModel *result = (AccountModel *)responseObject;
                                  [AccountService defaultService].account = result.data;
                                  
                                  self.operateSuccessBlock();
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.babys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellDefault"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellDefault"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    Baby *baby = [self.babys objectAtIndex:section];
    if (row == 0) {
        cell.textLabel.text = @"孩子昵称";
        cell.detailTextLabel.text = baby.name;
        
    } else if (row == 1) {
        cell.textLabel.text = @"孩子性别";
        cell.detailTextLabel.text = baby.sex;
        
    } else {
        cell.textLabel.text = @"孩子生日";
        cell.detailTextLabel.text = baby.birthday;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView] - 1) {
        return 80;
    }
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    if (section == [self numberOfSectionsInTableView:tableView] - 1) {
        UIButton *button = [[UIButton alloc]init];
        button.height = 40;
        button.width = 280;
        button.left = (SCREEN_WIDTH - button.width) / 2;
        button.top = 30;
        [button setTitle:@"完成" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onFinishClicked) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:@"BgLargeButtonNormal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"BgLargeButtonDisable"] forState:UIControlStateDisabled];
        [view addSubview:button];
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"输入孩子昵称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        alert.tag = indexPath.section;
        [alert show];
        
    } else if (indexPath.row == 1) {
        [self showSexPicker:indexPath.section];
        
    } else {
        [self showDatePicker:indexPath.section];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) { //修改宝宝姓名
        //得到输入框
        UITextField *tf=[alertView textFieldAtIndex:0];
        ((Baby *)[self.babys objectAtIndex:alertView.tag]).name = tf.text;
        [self.tableView reloadData];
    }
}

#pragma mark - sex picker

-(void)showSexPicker:(NSInteger)child {
    UIActionSheet *sexSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"男",@"女",nil];
    sexSheet.tag = child;
    [sexSheet showInView:[[UIApplication sharedApplication].delegate window]];
}

#pragma mark -
#pragma UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString * sex = buttonIndex == 0 ? @"男" : @"女";
    ((Baby *)[self.babys objectAtIndex:actionSheet.tag]).sex = sex;
    [self.tableView reloadData];
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
    ((Baby *)[self.babys objectAtIndex:datePickerSheet.tag]).birthday = dateString;
    [self.tableView reloadData];
}


@end
