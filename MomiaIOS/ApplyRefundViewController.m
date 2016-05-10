//
//  ApplyCaskBackViewController.m
//  MomiaIOS
//
//  Created by mosl on 16/4/21.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "ApplyRefundViewController.h"
#import "RefundDetailViewController.h"
#import "CheckBoxCell.h"

@interface ApplyRefundViewController ()

@property (nonatomic, assign) NSInteger selectRefundReasonIndex;

@end

@implementation ApplyRefundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请退款";
    [self setUpRefundBtn];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CheckBoxCell" bundle:nil] forCellReuseIdentifier:@"CheckBoxCell"];
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
    button.backgroundColor = MO_APP_ThemeColor;
    
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
    if (indexPath.section == 0) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellDefault"];
        cell.textLabel.text = @"退款金额";
        cell.detailTextLabel.textColor = [UIColor redColor];
        cell.detailTextLabel.text = @"$399";
    } else if (indexPath.section == 1){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellDefault"];
        cell.textLabel.text = @"原路退回(3-10个工作日内到账，0手续费）";
    } else {
        CheckBoxCell *checkBoxCell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckBoxCell"];
        if (indexPath.row == self.selectRefundReasonIndex) {
            [checkBoxCell.checkDotView checked];
        } else {
             [checkBoxCell.checkDotView uncheck];
        }
        switch (indexPath.row) {
            case 0:
                checkBoxCell.detailLabel.text = @"买多了/买错了";
                break;
            case 1:
                checkBoxCell.detailLabel.text = @"计划有变，没时间上课";
                break;
            case 2:
                checkBoxCell.detailLabel.text = @"后悔了，不想要了";
                break;
            case 3:
                checkBoxCell.detailLabel.text = @"预约到不想上的课";
                break;
            default:
                checkBoxCell.detailLabel.text = @"其他原因";
                break;
        }
        cell = checkBoxCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    label.textColor = [UIColor darkGrayColor];
    return view;
}

-(void)commitRefund {
    
    NSDictionary * paramDic = @{@"oid":self.oid,@"fee":self.model.data.totalFee,@"message":@"买错了"};
    NSString *orderRefundURL = URL_APPEND_PATH(@"/subject/order/refund");
    [[HttpService defaultService]POST:orderRefundURL
                          parameters:paramDic
                      JSONModelClass:nil
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 RefundDetailViewController *refundVC = [[RefundDetailViewController alloc]init];
                                 [self.navigationController pushViewController:refundVC animated:YES];
                             }
     
                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 
                             }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        
        self.selectRefundReasonIndex = indexPath.row;
        [self.tableView reloadData];
    }
}

-(void)onRefundBtnClicked{
    
    [self commitRefund];
}

@end
