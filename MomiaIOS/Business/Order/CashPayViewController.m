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
#import "CashPayTopHeaderView.h"

static NSString * identifier = @"HeaderViewCashPayBottomHeader";

@interface CashPayViewController ()

@property(nonatomic,strong) NSArray * topDataArray;
@property(nonatomic,strong) NSArray * bottomDataArray;
@property(nonatomic,strong) NSArray * sectionArray;

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
   if(section == 0) return [CashPayTopHeaderView heightWithTableView:tableView data:self.sectionArray[section]];
    return 35.0f;
}


- (void)tableView:(UITableView *)tableView
willDisplayHeaderView:(UIView *)view
       forSection:(NSInteger)section
{
    if(section == 1) {
        UITableViewHeaderFooterView * header =(UITableViewHeaderFooterView *) view;
        header.textLabel.font = [UIFont systemFontOfSize:18.0f];
    }
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view;
    if(section == 0) {
        CashPayTopHeaderView * header = [CashPayTopHeaderView headerViewWithTableView:tableView];
        header.backgroundView = [[UIView alloc] init];
        header.backgroundView.backgroundColor = [UIColor colorWithRed:0/255.0 green:198/255.0 blue:128/255.0 alpha:1.0];
        header.data = self.sectionArray[section];
        view = header;
    } else {
        UITableViewHeaderFooterView * standardHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
        standardHeader.textLabel.text = @"支付方式";
        view = standardHeader;
    }
    return view;
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
    
    NSDictionary * sDic1 = @{@"title":@"探秘自然博物馆，和大恐龙亲密约会!",@"desc":@"6月16日 周二"};
    
    self.sectionArray = @[sDic1];
 
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:identifier];
    [CashPayTopHeaderView registerHeaderViewWithTableView:self.tableView];
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
