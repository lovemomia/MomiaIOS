//
//  CashPayViewController.m
//  MomiaIOS
//
//  Created by Owen on 15/6/10.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "CashPayViewController.h"
#import "CashPayTopCell.h"
#import "CashPayBottomCell.h"

@interface CashPayViewController ()

@property(nonatomic,strong) NSArray * topDataArray;
@property(nonatomic,strong) NSArray * bottomDataArray;

@end

@implementation CashPayViewController

#pragma mark - datasource & delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        return self.topDataArray.count;
    } else {
        return self.bottomDataArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section == 0) {
        return [CashPayTopCell heightWithTableView:tableView forIndexPath:indexPath data:self.topDataArray[row]];
    } else {
        return [CashPayBottomCell heightWithTableView:tableView forIndexPath:indexPath data:self.bottomDataArray[row]];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    UITableViewCell * cell;
    if(section == 0) {
        CashPayTopCell * top = [CashPayTopCell cellWithTableView:tableView forIndexPath:indexPath];
        top.data = self.topDataArray[row];
        cell = top;
    } else {
        CashPayBottomCell * bottom = [CashPayBottomCell cellWithTableView:tableView forIndexPath:indexPath];
        bottom.data = self.bottomDataArray[row];
        cell = bottom;
    }
    return cell;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"收银台";
    NSDictionary * dic1 = @{@"title":@"成人1+儿童1",@"price":@"1 * ￥50"};
    NSDictionary * dic2 = @{@"title":@"成人2+儿童1",@"price":@"1 * ￥100"};
    NSDictionary * dic3 = @{@"title":@"需支付",@"price":@"￥150"};
    self.topDataArray = @[dic1,dic2,dic3];
    
    NSDictionary * bDic1 = @{@"image":[UIImage imageNamed:@"pay_order"],@"pay":@"支付宝",@"desc":@"支付宝账号支付，银行卡支付"};
    NSDictionary * bDic2 = @{@"image":[UIImage imageNamed:@"pay_wx"],@"pay":@"微信支付",@"desc":@"微信钱包，银行卡支付"};
    self.bottomDataArray = @[bDic1,bDic2];
    
    [CashPayTopCell registerCellWithTableView:self.tableView];
    [CashPayBottomCell registerCellWithTableView:self.tableView];
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
