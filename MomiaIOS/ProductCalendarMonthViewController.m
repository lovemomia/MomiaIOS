//
//  ProductCalendarMonthViewController.m
//  MomiaIOS
//
//  Created by Owen on 15/7/17.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ProductCalendarMonthViewController.h"
#import "ProductCalendarTitleCell.h"
#import "ProductCalendarCell.h"

static NSString * productCalendarMonthTitleIdentifier = @"CellProductCalendarMonthTitle";
static NSString * productCalendarMonthIdentifier = @"CellProductCalendarMonth";

@interface ProductCalendarMonthViewController ()

@end

@implementation ProductCalendarMonthViewController

-(UITableViewStyle)tableViewStyle
{
    return UITableViewStyleGrouped;
}

-(UITableViewCellSeparatorStyle)tableViewCellSeparatorStyle
{
    return UITableViewCellSeparatorStyleSingleLine;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 + 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if(row == 0) {
        return 46;
    }
    return 104.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    UITableViewCell * cell;
    if(row == 0) {
        ProductCalendarTitleCell * title = [ProductCalendarTitleCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:productCalendarMonthTitleIdentifier];
        cell = title;
    } else {
        ProductCalendarCell * content = [ProductCalendarCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:productCalendarMonthIdentifier];
        cell = content;
    }
    return cell;
}

-(void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [ProductCalendarTitleCell registerCellWithTableView:self.tableView withIdentifier:productCalendarMonthTitleIdentifier];
    [ProductCalendarCell registerCellWithTableView:self.tableView withIdentifier:productCalendarMonthIdentifier];
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
