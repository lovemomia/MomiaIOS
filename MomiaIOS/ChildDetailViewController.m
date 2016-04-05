//
//  ChildDetailViewController.m
//  MomiaIOS
//
//  Created by mosl on 16/4/5.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "ChildDetailViewController.h"
#import "DatePickerSheet.h"

@interface ChildDetailViewController ()<UIActionSheetDelegate,DatePickerSheetDelegate>

@end

@implementation ChildDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"宝宝信息";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 80;
    }
    return 48;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 4;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        return 10;
    }
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 1) {
    
    }
    else if (indexPath.row == 2) {
        [self showSexPicker:2];
    }else if(indexPath.row == 3){
        [self showDatePicker:3];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    if (section == [self numberOfSectionsInTableView:tableView] - 1) {
        UIButton *button = [[UIButton alloc]init];
        button.height = 40;
        button.width = 280;
        button.left = (SCREEN_WIDTH - button.width) / 2;
        button.top = 30;
        [button setTitle:@"确认修改" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onConfirmClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:@"BgLargeButtonNormal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"BgLargeButtonDisable"] forState:UIControlStateDisabled];
        
        [view addSubview:button];
    }
    return view;
}

-(void)onConfirmClick:(id)sender{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    static NSString *CellDefault = @"DefaultCell";
    static NSString *CellLogo = @"LogoCell";
    static NSString *childName = @"ChildNameCellIdentifer";
    UITableViewCell *cell;
    
    if ((section == 0) && row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellLogo];
        if (cell == nil) {
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"PersonLogoCell" owner:self options:nil];
            cell = [arr objectAtIndex:0];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UILabel *titleLabel = (UILabel *)[cell viewWithTag:2];
            titleLabel.text = @"宝宝靓照";
        }
        
    } else if(section == 0 && row == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:childName];
        if(cell == nil){
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"MineInfoCell" owner:self options:nil];
            cell = [arr objectAtIndex:2];
            UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
            titleLabel.text = @"姓名";
        }
    }else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellDefault];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellDefault];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        cell.textLabel.textColor = UIColorFromRGB(0x333333);
        cell.textLabel.font = [UIFont systemFontOfSize: 15.0];
        cell.detailTextLabel.textColor = UIColorFromRGB(0x999999);
        cell.detailTextLabel.font = [UIFont systemFontOfSize: 15.0];
        
        if (section == 0 && row == 1) {
            cell.textLabel.text = @"姓名";
        }else if(section == 0 && row == 2){
            cell.textLabel.text = @"性别";
        }else if(section == 0 && row ==3){
            cell.textLabel.text = @"生日";
        }
    }
    return cell;
}

-(void)showSexPicker:(NSInteger)tag {
    UIActionSheet *sexSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女",nil];
    sexSheet.tag = tag;
    [sexSheet showInView:[[UIApplication sharedApplication].delegate window]];
}

- (void)showDatePicker:(NSInteger)tag {
    DatePickerSheet * datePickerSheet = [DatePickerSheet getInstance];
    [datePickerSheet initializationWithMaxDate:nil
                                   withMinDate:nil
                            withDatePickerMode:UIDatePickerModeDate
                                  withDelegate:self];
    datePickerSheet.tag = tag;
    [datePickerSheet showDatePickerSheet];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}

-(void) datePickerSheet:(DatePickerSheet*)datePickerSheet chosenDate:(NSDate*)date{
    
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
