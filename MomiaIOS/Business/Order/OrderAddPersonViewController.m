//
//  OrderAddPersonViewController.m
//  MomiaIOS
//
//  Created by Owen on 15/6/10.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "OrderAddPersonViewController.h"
#import "ConvertFromXib.h"
#import "DatePickerSheet.h"

@interface OrderAddPersonViewController ()<DatePickerSheetDelegate,UIActionSheetDelegate>

@property(nonatomic,strong) NSArray * dataArray;

@end

@implementation OrderAddPersonViewController

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifierName = @"CellOrderAddPersonName";
    static NSString * identifierSex = @"CellOrderAddPersonSex";
    static NSString * identifierBirth = @"CellOrderAddPersonBirth";
    NSInteger row = indexPath.row;
    NSDictionary * dic  = self.dataArray[row];
    UITableViewCell * cell;
    if(row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifierName];
        if(!cell) {
            cell = [ConvertFromXib convertObjectWithNibNamed:@"OrderAddPersonCell" withIndex:0];
        }
        UITextField * field = (UITextField *)[cell viewWithTag:1001];
        field.delegate = self;
        field.text = [dic objectForKey:@"content"];
    } else if(row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifierSex];
        if(!cell) {
            cell = [ConvertFromXib convertObjectWithNibNamed:@"OrderAddPersonCell" withIndex:1];
        }
        UIButton * btn = (UIButton *)[cell viewWithTag:1002];
        [btn addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:[dic objectForKey:@"content"] forState:UIControlStateNormal];

    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:identifierBirth];
        if(!cell) {
            cell = [ConvertFromXib convertObjectWithNibNamed:@"OrderAddPersonCell" withIndex:2];
        }
        UIButton * btn = (UIButton *)[cell viewWithTag:1003];
        [btn addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:[dic objectForKey:@"content"] forState:UIControlStateNormal];

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
    NSLog(@"index:%ld",buttonIndex);
    NSString * sex = buttonIndex == 0 ? @"男" : @"女";
    NSMutableDictionary * dic = self.dataArray[1];
    [dic setObject:sex forKey:@"content"];
    [self.tableView reloadData];
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
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [formatter stringFromDate:date];
    NSMutableDictionary * dic = self.dataArray[2];
    [dic setObject:dateString forKey:@"content"];
    [self.tableView reloadData];
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"添加出行人";
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    NSMutableDictionary * dic1 = [[NSMutableDictionary alloc] init];
    [dic1 setObject:@"" forKey:@"content"];
    NSMutableDictionary * dic2 = [[NSMutableDictionary alloc] init];
    [dic2 setObject:@"点击选择性别" forKey:@"content"];
    NSMutableDictionary * dic3 = [[NSMutableDictionary alloc] init];
    [dic3 setObject:@"点击选择生日" forKey:@"content"];

    self.dataArray = @[dic1,dic2,dic3];

    
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
