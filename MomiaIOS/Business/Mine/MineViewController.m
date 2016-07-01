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
#import "ChatListViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "NSString+MOURLEncode.h"

@interface MineViewController ()

@end

@implementation MineViewController

- (BOOL)isNavDarkStyle {
    
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"我的";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"TitleMsg"] style:UIBarButtonItemStylePlain target:self action:@selector(onTitleBtnClick)];
    
    [[AccountService defaultService] addListener:self];
    
    //获取我的问题，答案
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)onTitleBtnClick {
    NSString *title = @"系统通知";
    [self openURL:[NSString stringWithFormat:@"chatpublic?type=6&targetid=10000&username=%@&title=%@", [title URLEncodedString], [title URLEncodedString]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[AccountService defaultService]removeListener:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onMineDotChanged" object:nil];
}

- (void)onAccountChange {
    [self.tableView reloadData];
}

// 单击设置
- (void)onSettingClicked {
    NSURL *url = [NSURL URLWithString:@"setting"];
    [[UIApplication sharedApplication ] openURL:url];
}

- (void)onLoginClicked {
    [[AccountService defaultService] login:self success:nil];
}

#pragma mark - tableview delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1 && [AccountService defaultService].account.role.integerValue == 9) {
        return 3;
    } else if(section == 1){
        return 2;
    }else if (section == 2) {
        return 3;
    } else if (section == 0) {
        return 1;
    }
    return 3;
}

//有四个section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
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
                [[UIApplication sharedApplication ] openURL:MOURL(@"personinfo")];
                
                [MobClick event:@"Mine_PersonInfo"];
            }
        }
            break;
        case 1:
            if(row == 0) {
                [self openURL:@"myquestion"];
                
                [MobClick event:@"Mine_Book"];
                
            } else if (row == 1 && [AccountService defaultService].account.role.integerValue == 9 ) {
               [self openURL:@"myanswer"];
                
                [MobClick event:@"Mine_Booked"];
            } else {
                [self openURL:@"myasset"];
                
                [MobClick event:@"Mine_Account"];
            }
            break;
            
        case 2:
            if(row == 0) {
                [self openURL:@"myorderlist"];
                
                [MobClick event:@"Mine_Order"];
                
            } else if (row == 1) {
                [self openURL:@"couponlist?status=0"];
                
                [MobClick event:@"Mine_Coupon"];
                
            } else {
                [self openURL:@"share"];
                
                [MobClick event:@"Mine_Gift"];
            }
            break;
        case 3:
            if(row == 0) {
                [self openURL:@"feedback"];
                
                [MobClick event:@"Mine_Feedback"];
                
            } else {
                [self openURL:@"setting"];
                
                [MobClick event:@"Mine_Setting"];
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
                subTitleLabel.text = [NSString stringWithFormat:@"%@", [account ageWithDateOfBirth]];
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
        commonCell.dotIv.hidden = YES;
        
        switch (section) {
            case 1:
                if (row == 0) {
                    commonCell.titleLabel.text = @"我问";
                    commonCell.iconIv.image = [UIImage imageNamed:@"IconBooking"];
                } else if (row == 1 && [AccountService defaultService].account.role.integerValue == 9) {
                    commonCell.titleLabel.text = @"我答";
                    commonCell.iconIv.image = [UIImage imageNamed:@"IconBooked"];
                } else {
                    commonCell.titleLabel.text = @"我的账户";
                    commonCell.iconIv.image = [UIImage imageNamed:@"IconBooked"];
                }
                break;
            case 2:
                if (row == 0) {
                    commonCell.titleLabel.text = @"我的订单";
                    commonCell.iconIv.image = [UIImage imageNamed:@"IconOrder"];
                } else if (row == 1){
                    commonCell.titleLabel.text = @"我的红包";
                    commonCell.iconIv.image = [UIImage imageNamed:@"IconCoupon"];
                } else {
                    commonCell.titleLabel.text = @"推荐有奖";
                    commonCell.iconIv.image = [UIImage imageNamed:@"IconGift"];
                    
                    commonCell.subTitleLabel.text = @" 抢50元红包 ";
                    commonCell.subTitleLabel.textColor = MO_APP_TextColor_red;
                    commonCell.subTitleLabel.layer.borderColor = [MO_APP_TextColor_red CGColor];
                    commonCell.subTitleLabel.layer.borderWidth = 1.0f;
                    commonCell.subTitleLabel.layer.cornerRadius = 2.0;
                    commonCell.subTitleLabel.layer.masksToBounds = YES;
                }
                break;
                
            case 3:
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
