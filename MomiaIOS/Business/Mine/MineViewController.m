//
//  MineViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/4/23.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MineViewController.h"

@interface MineViewController ()

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"我的";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(onSettingClicked)];
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

// 单击设置
- (void)onSettingClicked {
    
    NSURL *url = [NSURL URLWithString:@"momia://setting"];
    [[UIApplication sharedApplication ] openURL:url];
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
    if (section >= 1) {
        return 2;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    switch (section) {
        case 0:
        {
            NSURL *url = [NSURL URLWithString:@"momia://personinfo"];
            [[UIApplication sharedApplication ] openURL:url];
        }
            break;
        case 1:
            if(row == 0) {
                NSURL *url = [NSURL URLWithString:@"momia://mycollection"];
                [[UIApplication sharedApplication ] openURL:url];
            } else {
                NSURL *url = [NSURL URLWithString:@"momia://mysuggest"];
                [[UIApplication sharedApplication ] openURL:url];
            }
            break;
        case 2:
            if(row == 0) {
                
                
            } else {
                [self shareToFriend];
            }
            break;
            
        default:
            break;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    static NSString *CellDefault = @"DefaultCell";
    static NSString *CellInfo = @"InfoCell";
    UITableViewCell *cell;
    if (section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellDefault];
        if (cell == nil) {
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"MineInfoCell" owner:self options:nil];
            cell = [arr objectAtIndex:0];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:CellInfo];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellInfo];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        switch (section) {
            case 1:
                if (row == 0) {
                    cell.textLabel.text = @"我的收藏";
                } else {
                    cell.textLabel.text = @"我的推荐";
                }
                break;
            case 2:
                if (row == 0) {
                    cell.textLabel.text = @"意见反馈";
                } else {
                    cell.textLabel.text = @"推荐给好友";
                }
                break;
            default:
                break;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)shareToFriend {
    
}


@end
