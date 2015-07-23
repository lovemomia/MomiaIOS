//
//  SettingViewController.m
//  MomiaIOS
//
//  Created by Owen on 15/5/12.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"设置";
   
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


#pragma mark - tableview delegate & datasource

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section == 0) {
//        return 59;
//    }
//    return 44;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    static NSString *CellDefault = @"DefaultCell";
    static NSString *CellMsg = @"MsgCell";
    
    UITableViewCell *cell;
    
    if(section == 0 && row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellMsg];
        if(cell == nil) {
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"SettingMsgCell" owner:self options:nil];
            cell = [arr objectAtIndex:0];
        }
        
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:CellDefault];
        if(cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellDefault];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.textColor = UIColorFromRGB(0x333333);
        cell.textLabel.font = [UIFont systemFontOfSize: 15.0];
        
        cell.detailTextLabel.textColor = UIColorFromRGB(0x999999);
        cell.detailTextLabel.font = [UIFont systemFontOfSize: 12.0];
        
        switch (section) {
            case 0:
                if (row == 1) {
                    cell.textLabel.text = @"清除缓存";
                }
                break;
            case 1:
                if (row == 0) {
                    cell.textLabel.text = @"版本更新";
                    cell.detailTextLabel.text = @"已是最新版";
                } else {
                    cell.textLabel.text = @"关于我们";
                }
                break;
            default:
                break;
        }

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}


@end
