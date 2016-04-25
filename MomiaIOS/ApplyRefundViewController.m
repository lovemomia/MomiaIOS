//
//  ApplyCaskBackViewController.m
//  MomiaIOS
//
//  Created by mosl on 16/4/21.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "ApplyRefundViewController.h"
#import "RefundDetailViewController.h"

@interface ApplyRefundViewController ()

@end

@implementation ApplyRefundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请退款";
    [self setUpRefundBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setUpRefundBtn{
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    view.frame = CGRectMake(0, SCREEN_HEIGHT - 60 - 64, SCREEN_WIDTH, 60);
    UIButton *button = [[UIButton alloc]init];
    [view addSubview:button];
    
    button.height = 40;
    button.width = 280;
    button.left = (SCREEN_WIDTH - button.width) / 2;
    button.top = 10;
    [button setTitle:@"确认退款" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onRefundBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"BgRedLargeButtonNormal"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"BgLargeButtonDisable"] forState:UIControlStateDisabled];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    } else {
        return 5;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    if (indexPath.section == 0 ) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellDefault"];
        cell.textLabel.text = @"退款金额";
        cell.detailTextLabel.text = @" $ 1999";
    } else if (indexPath.section == 1){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellDefault"];
        cell.textLabel.text = @"原路退回(3-10个工作日内到账，0手续费";
    } else {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellDefault"];
        cell.textLabel.text = @"退款原因";
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 54.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    UILabel *label = [[UILabel alloc]init];
    [view addSubview:label];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.font = [UIFont systemFontOfSize:18];
    NSLayoutConstraint *centerConstraint = [NSLayoutConstraint constraintWithItem:label
                                                                        attribute:NSLayoutAttributeCenterY
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:view
                                                                        attribute:NSLayoutAttributeCenterY
                                                                       multiplier:1.0
                                                                         constant:0];
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:label
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:view
                                                                      attribute:NSLayoutAttributeLeading
                                                                     multiplier:1.0
                                                                       constant:15];
    [view addConstraint:leftConstraint];
    [view addConstraint:centerConstraint];
    
    if (section == 0) {
        label.text = @"职业梦想体系";
    } else if (section == 1){
        label.text = @"退款方式";
    } else {
        label.text = @"退款原因";
    }
    return view;
}

-(void)onRefundBtnClicked{
    
    RefundDetailViewController *refundVC = [[RefundDetailViewController alloc]init];
    [self.navigationController pushViewController:refundVC animated:YES];
}

@end
