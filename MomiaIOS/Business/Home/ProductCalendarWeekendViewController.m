//
//  ProductCalendarWeekendViewController.m
//  MomiaIOS
//
//  Created by Owen on 15/7/17.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ProductCalendarWeekendViewController.h"
#import "ProductCalendarCell.h"
static NSString * productCalendarWeekendIdentifier = @"CellProductCalendarWeekend";

@interface ProductCalendarWeekendViewController ()

@end

@implementation ProductCalendarWeekendViewController

-(UITableViewCellSeparatorStyle)tableViewCellSeparatorStyle
{
    return UITableViewCellSeparatorStyleSingleLine;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 104.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductCalendarCell * cell = [ProductCalendarCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:productCalendarWeekendIdentifier];
    
    return cell;
}

-(void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [ProductCalendarCell registerCellWithTableView:self.tableView withIdentifier:productCalendarWeekendIdentifier];

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
