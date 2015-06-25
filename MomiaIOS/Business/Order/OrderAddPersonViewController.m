//
//  OrderAddPersonViewController.m
//  MomiaIOS
//
//  Created by Owen on 15/6/10.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "OrderAddPersonViewController.h"
#import "DatePickerSheet.h"
#import "OrderAddPersonFillCell.h"
#import "OrderAddPersonSelectCell.h"

static NSString * orderAddPersonFillIdentifier = @"CellOrderAddPersonFill";
static NSString * orderAddPersonSelectIdentifier = @"CellOrderAddPersonSelect";

@interface OrderAddPersonViewController ()<DatePickerSheetDelegate,UIActionSheetDelegate>


@end

@implementation OrderAddPersonViewController

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger row = indexPath.row;
    UITableViewCell * cell;
    if(row == 0) {
        OrderAddPersonFillCell * fill = [OrderAddPersonFillCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:orderAddPersonFillIdentifier];
        cell = fill;
    } else if(row == 1) {
        OrderAddPersonSelectCell * select = [OrderAddPersonSelectCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:orderAddPersonSelectIdentifier];
        cell = select;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52.0f;
}


- (IBAction)onSaveClick:(id)sender {
    
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    NSLog(@"index:%ld",buttonIndex);
//    NSString * sex = buttonIndex == 0 ? @"男" : @"女";
//    NSMutableDictionary * dic = self.dataArray[1];
//    [dic setObject:sex forKey:@"content"];
//    [self.tableView reloadData];
}


-(void)onBtnClick:(id)sender
{
    UIButton * btn = sender;
    if(btn.tag == 1002) {//单击的是选择性别
        [self showSexPicker];
    } else if(btn.tag == 1003) {//单击的是选择日期
        [self showDatePicker];
    }
}

-(void)showSexPicker {
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"男",@"女",nil];
    [sheet showInView:[[UIApplication sharedApplication].delegate window]];
}

- (void)showDatePicker {
    DatePickerSheet * datePickerSheet = [DatePickerSheet getInstance];
    [datePickerSheet initializationWithMaxDate:nil
                                   withMinDate:nil
                            withDatePickerMode:UIDatePickerModeDate
                                  withDelegate:self];
    [datePickerSheet showDatePickerSheet];
}

- (void) datePickerSheet:(DatePickerSheet*)datePickerSheet chosenDate:(NSDate*)date
{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyy-MM-dd";
//    NSString *dateString = [formatter stringFromDate:date];
//    NSMutableDictionary * dic = self.dataArray[2];
//    [dic setObject:dateString forKey:@"content"];
//    [self.tableView reloadData];
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"新增出行人";
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [OrderAddPersonFillCell registerCellWithTableView:self.tableView withIdentifier:orderAddPersonFillIdentifier];
    [OrderAddPersonSelectCell registerCellWithTableView:self.tableView withIdentifier:orderAddPersonSelectIdentifier];
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

@end
