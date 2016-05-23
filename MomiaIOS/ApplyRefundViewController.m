//
//  ApplyCaskBackViewController.m
//  MomiaIOS
//
//  Created by mosl on 16/4/21.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "ApplyRefundViewController.h"
#import "CheckBoxCell.h"
#import "CommonHeaderView.h"
#import "OrderDetailModel.h"

@interface ApplyRefundViewController ()

@property (nonatomic, assign) NSInteger selectRefundReasonIndex;
@property (nonatomic, strong) NSNumber *oid;
@property (nonatomic, strong) OrderDetailModel *model;
@property (nonatomic, strong) NSArray *refundReasonArray;

@end

@implementation ApplyRefundViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.oid = [params objectForKey:@"oid"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请退款";
    
    [CommonHeaderView registerCellFromNibWithTableView:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"CheckBoxCell" bundle:nil] forCellReuseIdentifier:@"CheckBoxCell"];
    
    self.refundReasonArray = @[@"买多了/买错了",@"计划有变，没时间上课",@"后悔了，不想要了",@"预约到不想上的课",@"其他原因"];
    [self requestData];
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
    [button addTarget:self action:@selector(commitRefund) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = MO_APP_ThemeColor;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (!self.model) {
        [self.view showLoadingBee];
        return 0;
    }
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    } else {
        return 5;
    }
    return 0;
}

- (void)requestData {
    if (self.model == nil) {
        [self.view showLoadingBee];
    }
    if (!self.oid) {
        [self.view removeLoadingBee];
        return;
    }
    NSDictionary * paramDic = @{@"oid":self.oid};
    NSString *orderDetailURL = URL_APPEND_PATH(@"/subject/order/detail");
    [[HttpService defaultService]GET:orderDetailURL
                          parameters:paramDic
                           cacheType:CacheTypeDisable
                      JSONModelClass:[OrderDetailModel class]
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 [self.view removeLoadingBee];
                                 [self setUpRefundBtn];
                                 self.model = responseObject;
                                 [self.tableView reloadData];
                             }
     
                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 [self.view removeLoadingBee];
                                 [self showDialogWithTitle:nil message:error.message];
                             }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header;
    header = [CommonHeaderView cellWithTableView:self.tableView];
    if (section == 0) {
        ((CommonHeaderView * )header).data = self.model.data.title;
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
        UILabel *feeLabel = [cell viewWithTag:2001];
        feeLabel.text = [NSString stringWithFormat:@"￥%@",self.model.data.payedFee];
    } else if (indexPath.section == 1){
        
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"RefundText" owner:self options:nil];
        cell = [array objectAtIndex:1];
    } else {
        CheckBoxCell *checkBoxCell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckBoxCell"];
        checkBoxCell.detailLabel.text = [self.refundReasonArray objectAtIndex:indexPath.row];
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
    
    NSDictionary * paramDic = @{@"oid":self.oid,@"fee":self.model.data.totalFee,@"message":[self.refundReasonArray objectAtIndex:self.selectRefundReasonIndex]};
    NSString *orderRefundURL = URL_APPEND_PATH(@"/subject/order/refund");
    [[HttpService defaultService]POST:orderRefundURL
                          parameters:paramDic
                      JSONModelClass:nil
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 
                                 [self.navigationController popViewControllerAnimated:NO];
                                 [[NSNotificationCenter defaultCenter]postNotificationName:@"updateOrderList" object:nil];
                                 [self openURL:[NSString stringWithFormat:@"refunddetail?oid=%@",self.oid]];
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

@end
