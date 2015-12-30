//
//  AboutViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/29.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"关于我们";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview delegate & datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self openURL:@"web?url=http%3a%2f%2fitunes.apple.com%2fapp%2fid1019473117%3fmt%3d8"];
    } else {
        [self openURL:@"web?url=http://www.sogokids.com/agreement.html"];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    
    static NSString *CellDefault = @"DefaultCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellDefault];
    if(cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellDefault];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.textColor = UIColorFromRGB(0x333333);
    cell.textLabel.font = [UIFont systemFontOfSize: 15.0];
    
    cell.detailTextLabel.textColor = UIColorFromRGB(0x999999);
    cell.detailTextLabel.font = [UIFont systemFontOfSize: 12.0];
    
    if (row == 0) {
        cell.textLabel.text = @"喜欢我们，打分鼓励";
    } else {
        cell.textLabel.text = @"用户协议";
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 133;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"AboutHeaderView" owner:self options:nil];
    UIView *view = [arr objectAtIndex:0];
    UILabel *versionLabel = (UILabel *)[view viewWithTag:1001];
    versionLabel.text = [NSString stringWithFormat:@"当前版本：V%@", MO_APP_VERSION];
    return view;
}

@end
