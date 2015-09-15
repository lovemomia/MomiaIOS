//
//  SettingViewController.m
//  MomiaIOS
//
//  Created by Owen on 15/5/12.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "SettingViewController.h"
#import "ThirdShareHelper.h"
#import "SGActionView.h"
#import "PushManager.h"
#import "AppDelegate.h"


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

-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isOn = [switchButton isOn];
    if (isOn) {
        [[PushManager shareManager]openPush:(AppDelegate *)[[UIApplication sharedApplication] delegate]];
        
    }else {
        [[PushManager shareManager]closePush];
    }
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
   
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                [MBProgressHUD hideHUDForView:self.view animated:NO];
                [self.tableView reloadData];
            }];
        }
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            ThirdShareHelper *helper = [ThirdShareHelper new];
            [SGActionView showGridMenuWithTitle:@"分享给好友"
                                     itemTitles:@[ @"微信好友", @"微信朋友圈"]
                                         images:@[ [UIImage imageNamed:@"IconShareWechat"],
                                                   [UIImage imageNamed:@"IconShareWechatTimeline"]]
                                 selectedHandle:^(NSInteger index) {
                                     NSString *url = @"http://m.duolaqinzi.com/";
                                     UIImage *thumb = [UIImage imageNamed:@"IconShareLogo"];
                                     NSString *title = @"松果亲子，约上玩伴，探索世界";
                                     NSString *desc = @"这里有最新鲜、最有趣、最具特色的亲子活动、手工DIY、游乐场、家庭出游等服务，来这里给孩子最美好的童年吧";
                                     if (index == 1) {
                                         [helper shareToWechat:url thumb:thumb title:title desc:desc scene:1];
                                     } else if (index == 2) {
                                         [helper shareToWechat:url thumb:thumb title:title desc:desc scene:2];
                                     }
                                 }];
            
        } else {
            [self openURL:@"duola://about"];
        }
    }

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
        UISwitch *pushSwitch = (UISwitch *)[cell viewWithTag:1001];
        [pushSwitch setOn:![[PushManager shareManager] isPushClose]];
        [pushSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        
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
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1fM", (float)[[SDImageCache sharedImageCache] getSize] / (1024 * 1024)];
                }
                break;
            case 1:
                if (row == 0) {
                    cell.textLabel.text = @"分享给好友";
                } else {
                    cell.textLabel.text = @"关于我们";
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


@end
