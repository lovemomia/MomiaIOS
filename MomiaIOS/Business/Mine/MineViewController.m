//
//  MineViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/4/23.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MineViewController.h"
#import "FeedbackViewController.h"
#import "Child.h"
#import "CommonTableViewCell.h"

@interface MineViewController ()

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"我的";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(onSettingClicked)];
    [[AccountService defaultService] addListener:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[AccountService defaultService]removeListener:self];
}

- (void)onAccountChange {
    [self.tableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// 单击设置
- (void)onSettingClicked {
    NSURL *url = [NSURL URLWithString:@"duola://setting"];
    [[UIApplication sharedApplication ] openURL:url];
}

- (void)onLoginClicked {
    [[AccountService defaultService] login:self];
}

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
    if (section == 0 || section == 2) {
        return 1;
    }
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    switch (section) {
        case 0:
        {
            if ([[AccountService defaultService] isLogin]) {
                NSURL *url = [NSURL URLWithString:@"duola://personinfo"];
                [[UIApplication sharedApplication ] openURL:url];
            }
        }
            break;
        case 1:
            if(row == 0) {
                [self openURL:@"duola://bookedcourselist"];
            } else {
               [self openURL:@"duola://bookingsubjectlist"];
            }
            break;
        case 2:
            if (row == 0) {
                if ([[AccountService defaultService]isLogin]) {
                    [self openURL:[NSString stringWithFormat:@"duola://userinfo?uid=%@&me=1", [AccountService defaultService].account.uid]];
                }
                
            }
            break;
        case 3:
            if(row == 0) {
                [self openURL:@"duola://myorderlist"];
            } else {
                [self openURL:@"duola://couponlist?status=0"];
            }
            break;
        case 4:
            if(row == 0) {
                [self openURL:@"duola://feedback"];
                
            } else {
                [self openURL:@"duola://setting"];
            }
            break;
            
        default:
            break;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    static NSString *CellUser = @"CellUser";
    static NSString *CellLogin = @"CellLogin";
    static NSString *CellCommon = @"CommonTableViewCell";
    UITableViewCell *cell;
    if (section == 0) {
        if ([[AccountService defaultService] isLogin]) {
            cell = [tableView dequeueReusableCellWithIdentifier:CellUser];
            if (cell == nil) {
                NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"MineInfoCell" owner:self options:nil];
                cell = [arr objectAtIndex:0];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            Account *account = [AccountService defaultService].account;
            
            UIImageView *userPic = (UIImageView *)[cell viewWithTag:1];
            if (account.avatar) {
                [userPic sd_setImageWithURL:[NSURL URLWithString:account.avatar]];
            }
            
            UILabel *titleLabel = (UILabel *)[cell viewWithTag:2];
            titleLabel.text = account.nickName;
            
            UILabel *subTitleLabel = (UILabel *)[cell viewWithTag:3];
            
            if ([account getBigChild]) {
                subTitleLabel.text = [NSString stringWithFormat:@"%@孩%@", [account getBigChild].sex, [account ageWithDateOfBirth]];
            }
            
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:CellLogin];
            if (cell == nil) {
                NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"MineInfoCell" owner:self options:nil];
                cell = [arr objectAtIndex:1];
            }
            UIButton *loginBtn = (UIButton *)[cell viewWithTag:1001];
            [loginBtn addTarget:self action:@selector(onLoginClicked) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:CellCommon];
        if (cell == nil) {
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"CommonTableViewCell" owner:self options:nil];
            cell = [arr objectAtIndex:0];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        CommonTableViewCell *commonCell = (CommonTableViewCell *)cell;
//        cell.textLabel.textColor = UIColorFromRGB(0x333333);
//        cell.textLabel.font = [UIFont systemFontOfSize: 16.0];
        
        switch (section) {
            case 1:
                if (row == 0) {
                    commonCell.titleLabel.text = @"已选课程";
                    commonCell.iconIv.image = [UIImage imageNamed:@"IconBooked"];
                } else {
                    commonCell.titleLabel.text = @"待选课程";
                    commonCell.iconIv.image = [UIImage imageNamed:@"IconBooking"];
                }
                break;
            case 2:
                if (row == 0) {
                    commonCell.titleLabel.text = @"成长说";
                    commonCell.iconIv.image = [UIImage imageNamed:@"IconFeed"];
                }
                break;
            case 3:
                if (row == 0) {
                    commonCell.titleLabel.text = @"我的订单";
                    commonCell.iconIv.image = [UIImage imageNamed:@"IconOrder"];
                } else {
                    commonCell.titleLabel.text = @"我的红包";
                    commonCell.iconIv.image = [UIImage imageNamed:@"IconCoupon"];
                }                break;
            case 4:
                if (row == 0) {
                    commonCell.titleLabel.text = @"意见反馈";
                    commonCell.iconIv.image = [UIImage imageNamed:@"IconFeedback"];
                    
                } else {
                    commonCell.titleLabel.text = @"设置";
                    commonCell.iconIv.image = [UIImage imageNamed:@"IconSetting"];
                }
                break;
            default:
                break;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)shareToFriend {
    
}


@end
