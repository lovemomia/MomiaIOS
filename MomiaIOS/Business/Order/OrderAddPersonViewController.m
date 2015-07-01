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
#import "AddPersonModel.h"
#import "PostPersonModel.h"

static NSString * orderAddPersonFillIdentifier = @"CellOrderAddPersonFill";
static NSString * orderAddPersonSelectIdentifier = @"CellOrderAddPersonSelect";

@interface OrderAddPersonViewController ()<DatePickerSheetDelegate,UIActionSheetDelegate>

@property(nonatomic,strong) AddPersonModel * model;
@property(nonatomic,strong) UIActionSheet * sexSheet, * idSheet;
@property(nonatomic,strong) NSString * utoken;

@end

@implementation OrderAddPersonViewController

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    UITableViewCell * cell;
    if(row == 0 || row == 4) {
        OrderAddPersonFillCell * fill = [OrderAddPersonFillCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:orderAddPersonFillIdentifier];
        [fill setData:self.model withIndex:row];
        fill.selectionStyle = UITableViewCellSelectionStyleNone;
        fill.editingChanged = ^(UITextField * field) {
            if(row == 0) {
                self.model.name = field.text;
            } else {
                self.model.idNo = field.text;
            }
        };
        cell = fill;
    } else {
        OrderAddPersonSelectCell * select = [OrderAddPersonSelectCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:orderAddPersonSelectIdentifier];
        [select setData:self.model withIndex:row];
        cell = select;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger row = indexPath.row;
    if(row == 1) {//选择性别
        [self showSexPicker];
    } else if(row == 2) {//选择出生日期
        [self showDatePicker];
    } else if(row == 3) {//选择证件类型
        [self showIDPicker];
    }
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet == self.idSheet) {
        NSInteger idType = buttonIndex == 0 ? 1 : 2;
        self.model.idType = idType;
    } else if(actionSheet == self.sexSheet) {
        NSString * sex = buttonIndex == 0 ? @"男" : @"女";
        self.model.sex = sex;
    }
    [self.tableView reloadData];
}

-(void)showIDPicker
{
    NSLog(@"%@",self.idSheet);
    self.idSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"身份证",@"护照",nil];
    [self.idSheet showInView:[[UIApplication sharedApplication].delegate window]];

}


-(void)showSexPicker {
    self.sexSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"男",@"女",nil];
    [self.sexSheet showInView:[[UIApplication sharedApplication].delegate window]];
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
    self.model.birthday = dateString;
    [self.tableView reloadData];
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)onFinishedClick
{
    if(self.model.name.length == 0) {
        [AlertNotice showNotice:@"姓名不能为空"];
        return;
    }
    if(self.model.birthday.length == 0) {
        [AlertNotice showNotice:@"出生日期不能为空"];
        return;
    }
    if(self.model.idNo.length == 0) {
        [AlertNotice showNotice:@"证件号码不能为空"];
        return;
    }
    [self postPerson];
    
}

-(void)postPerson
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *params = @{@"utoken":self.utoken,@"participant":[self.model toJSONString]};
        
    [[HttpService defaultService]POST:URL_APPEND_PATH(@"/participant")
                           parameters:params
                       JSONModelClass:[PostPersonModel class]
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  [MBProgressHUD hideHUDForView:self.view animated:NO];
                                  [self.navigationController popViewControllerAnimated:YES];
                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"addPersonSuccess" object:nil];
                                
                              }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  [self showDialogWithTitle:nil message:error.message];
                              }];
}


-(instancetype)initWithParams:(NSDictionary *)params
{
    self = [super initWithParams:params];
    if(self) {
        self.utoken = [params objectForKey:@"utoken"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"新增出行人";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(onFinishedClick)];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [OrderAddPersonFillCell registerCellWithTableView:self.tableView withIdentifier:orderAddPersonFillIdentifier];
    [OrderAddPersonSelectCell registerCellWithTableView:self.tableView withIdentifier:orderAddPersonSelectIdentifier];
    self.model = [[AddPersonModel alloc] init];
    self.model.idType = 1;//默认证件类型为1;
    self.model.sex = @"男";
    
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
