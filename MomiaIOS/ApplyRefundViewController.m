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
#import "CommonHeaderView.h"

@interface ApplyRefundViewController ()

@property (nonatomic, assign) NSInteger selectRefundReasonIndex;

@end

@implementation ApplyRefundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请退款";
    [self setUpRefundBtn];
    
    [CommonHeaderView registerCellFromNibWithTableView:self.tableView];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
//section 头部
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header;
    header = [CommonHeaderView cellWithTableView:self.tableView];
    if (section == 0) {
        ((CommonHeaderView * )header).data = @"职业梦想体系";
    }else if (section == 1) {
        ((CommonHeaderView * )header).data  = @"退款方式";
    } else {
        ((CommonHeaderView * )header).data  = @"退款原因";
    }
    return header;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"RefundText" owner:self options:nil];
        cell = [array objectAtIndex:0];
    } else if (indexPath.section == 1){
        
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"RefundText" owner:self options:nil];
        cell = [array objectAtIndex:1];
    } else {
        CheckBoxCell *checkBoxCell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckBoxCell"];
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
        if (self.selectRefundReasonIndex == indexPath.row) {
            [checkBoxCell.checkBtn setImage:[UIImage imageNamed:@"IconChecked"] forState:UIControlStateNormal];
        } else {
            [checkBoxCell.checkBtn setImage:[UIImage imageNamed:@"IconUncheck"] forState:UIControlStateNormal];
        }
        cell = checkBoxCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001f;
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
