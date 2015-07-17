//
//  ProductCalendarViewController.m
//  MomiaIOS
//
//  Created by Owen on 15/7/16.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ProductCalendarViewController.h"
#import "ProductCalendarCell.h"
#import "ProductCalendarTitleCell.h"

static NSString * productCalendarTitleIdentifier = @"CellProductCalendarTitle";
static NSString * productCalendarIdentifier = @"CellProductCalendar";

@interface ProductCalendarViewController ()

@end

@implementation ProductCalendarViewController

-(UITableViewCellSeparatorStyle)tableViewCellSeparatorStyle
{
    return UITableViewCellSeparatorStyleSingleLine;
}

-(UITableViewStyle)tableViewStyle
{
    return UITableViewStyleGrouped;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 + 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    NSInteger row = indexPath.row;
    if(row == 0) {
        height = 46;
    } else {
        height = 104;
    }
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    NSInteger row = indexPath.row;
    if(row == 0) {
        cell = [ProductCalendarTitleCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:productCalendarTitleIdentifier];
    } else {
        cell = [ProductCalendarCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:productCalendarIdentifier];
    }
    return cell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"活动日历";
    [ProductCalendarTitleCell registerCellWithTableView:self.tableView withIdentifier:productCalendarTitleIdentifier];
    [ProductCalendarCell registerCellWithTableView:self.tableView withIdentifier:productCalendarIdentifier];
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
