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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"我的";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"TitleMsg"] style:UIBarButtonItemStylePlain target:self action:@selector(onTitleBtnClick)];
    
    [[AccountService defaultService] addListener:self];
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
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[AccountService defaultService]removeListener:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onMineDotChanged" object:nil];
}

- (void)onAccountChange {
//    [self updateConstrains];
    [self.tableView reloadData];
}

//-(void)updateConstrains{
//    
//}

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
    NSURL *url = [NSURL URLWithString:@"setting"];
    [[UIApplication sharedApplication ] openURL:url];
}

- (void)onLoginClicked {
    [[AccountService defaultService] login:self success:nil];
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
    } else if (section == 3) {
        return 3;
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
                [[UIApplication sharedApplication ] openURL:MOURL(@"personinfo")];
                
                [MobClick event:@"Mine_PersonInfo"];
            }
        }
            break;
        case 1:
            if(row == 0) {
                [self openURL:@"bookingsubjectlist"];
                
                [MobClick event:@"Mine_Book"];
                
            } else {
               [self openURL:@"bookedcourselist"];
                
                [MobClick event:@"Mine_Booked"];
            }
            break;
        case 2:
            if ([[AccountService defaultService]isLogin]) {
                [self openURL:[NSString stringWithFormat:@"userinfo?uid=%@&me=1", [AccountService defaultService].account.uid]];
            } else {
                [[AccountService defaultService] login:self success:^{
                    [self openURL:[NSString stringWithFormat:@"userinfo?uid=%@&me=1", [AccountService defaultService].account.uid]];
                }];
            }
            
            [MobClick event:@"Mine_Feed"];
            break;
            
        case 3:
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
        case 4:
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
                if (![[AccountService defaultService].account haveChildren]) { //没有小孩，更新约束
                    NSArray *constrains = cell.contentView.constraints;
                    UIView *adultImageView = [cell.contentView viewWithTag:1];
                    UIView *adultNameView = [cell.contentView viewWithTag:2];
                    UIView *childNameView = [cell.contentView viewWithTag:3];
                    
                    [childNameView removeFromSuperview]; //移除小孩名字Label
                    for (NSLayoutConstraint* constraint in constrains) {
                        NSLog(@"%@",constraint);
                        if (constraint.firstItem == adultNameView || constraint.secondItem == adultNameView) {
                            [cell.contentView removeConstraint:constraint];
                        }
                        NSLayoutConstraint *centerConstraint = [NSLayoutConstraint constraintWithItem:adultNameView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:adultNameView.superview attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0];
                        [cell.contentView addConstraint:centerConstraint]; //增加居中约束
                        
                        NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:adultNameView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:adultImageView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:10];
                        [cell.contentView addConstraint:trailingConstraint]; //增加左边间距
                    }
                    
                }
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
                    commonCell.titleLabel.text = @"预约课程";
                    commonCell.iconIv.image = [UIImage imageNamed:@"IconBooking"];
                } else {
                    commonCell.titleLabel.text = @"已选课程";
                    commonCell.iconIv.image = [UIImage imageNamed:@"IconBooked"];
                }
                break;
                
            case 2:
                commonCell.titleLabel.text = @"我的评价";
                commonCell.iconIv.image = [UIImage imageNamed:@"IconFeed"];
                break;
                
            case 3:
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
