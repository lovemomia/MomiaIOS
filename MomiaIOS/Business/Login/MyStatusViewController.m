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

@interface MyStatusViewController () <DatePickerSheetDelegate>

@end

@implementation MyStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"我的状态";
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
        cell.textLabel.text = @"备孕";
        
    } else if (row == 1) {
        cell.textLabel.text = @"我怀孕了";
        cell.detailTextLabel.text = @"选择预产期：";
        
    } else {
        cell.textLabel.text = @"宝宝出生了";
        cell.detailTextLabel.text = @"选择宝宝生日：";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self updateBabyDate:nil];
        
    } else if (indexPath.row == 1) {
        [self showDatePicker];
    } else {
        [self showDatePicker];
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

- (void)showDatePicker {
    DatePickerSheet * datePickerSheet = [DatePickerSheet getInstance];
    [datePickerSheet initializationWithMaxDate:nil
                                   withMinDate:nil
                            withDatePickerMode:UIDatePickerModeDate
                                  withDelegate:self];
    [datePickerSheet showDatePickerSheet];
}

#pragma mark - DatePickerSheetDelegate method
- (void) datePickerSheet:(DatePickerSheet*)datePickerSheet chosenDate:(NSDate*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [formatter stringFromDate:date];
    NSLog(@"dateString:%@", dateString);
    
    [self updateBabyDate:dateString];
}


@end
