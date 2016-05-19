//
//  RefundViewController.m
//  MomiaIOS
//
//  Created by mosl on 16/4/22.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "RefundDetailViewController.h"
#import "RefundLabelCell.h"
#import "RefundTimeLineCell.h"
#import "OrderDetailModel.h"
#import "Order.h"
#import "ApplyRefundViewController.h"

static NSString* RefundTimeLineCellIdentifier = @"RefundTimeLineCellIdentifier";
static NSString* RefundLableCellIdentifer = @"RefundLableCellIdentifer";

@interface RefundDetailViewController ()

@property (nonatomic, strong) NSNumber *oid;
@property (nonatomic, strong) OrderDetailModel *model;

@end

@implementation RefundDetailViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.oid = [params objectForKey:@"oid"];
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"退款详情";
    
    [RefundTimeLineCell registerCellFromNibWithTableView:self.tableView withIdentifier:RefundTimeLineCellIdentifier];
    [RefundLabelCell registerCellFromNibWithTableView:self.tableView withIdentifier:RefundLableCellIdentifer];
    [self requestData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (!self.model) {
        [self.view showLoadingBee];
        return 0;
    }
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 3;
    } else {
        return 4;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Order *order = self.model.data;
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        RefundLabelCell *refundLabelCell = [self.tableView dequeueReusableCellWithIdentifier:RefundLableCellIdentifer];
        switch (indexPath.row) {
            case 0:
                refundLabelCell.refundTextLabel.text = @"退款金额";
                refundLabelCell.refundDetailTextLabel.text = [NSString stringWithFormat:@"￥%@",order.payedFee];
                break;
            case 1:
                refundLabelCell.refundTextLabel.text = @"数量";
                refundLabelCell.refundDetailTextLabel.text = [NSString stringWithFormat:@"%@",order.count];
                break;
            default:
                refundLabelCell.refundTextLabel.text = @"退回账户";
                if (order.payType.intValue == 1) {
                    refundLabelCell.refundDetailTextLabel.text = @"支付宝账户";
                } else if(order.payType.intValue == 2) {
                    refundLabelCell.refundDetailTextLabel.text = @"微信账户";
                }
                
                break;
        }
        cell = refundLabelCell;
    } else {
        if (indexPath.row == 0) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellDefault"];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.text = @"退款流程";
        } else {
            RefundTimeLineCell *refundTimeLineCell = [self.tableView dequeueReusableCellWithIdentifier:RefundTimeLineCellIdentifier];
            switch (indexPath.row) {
                case 1:
                    [refundTimeLineCell.topLine setHidden:YES];
                    [refundTimeLineCell.numberLabel setText:@"1"];
                    [refundTimeLineCell.applyTitle setText:@"申请已提交"];
                    [refundTimeLineCell.applyDetail setText:@"您的退款申请已成功提交"];
                    break;
                case 2:
                    [refundTimeLineCell.numberLabel setText:@"2"];
                    [refundTimeLineCell.applyTitle setText:@"松果处理中"];
                    [refundTimeLineCell.applyDetail setText:@"您的退款申请已受理，松果会尽快完成审核,部分情况需要1-2个工作日。"];
                    break;
                case 3:
                    [refundTimeLineCell.numberLabel setText:@"3"];
                    [refundTimeLineCell.applyTitle setText:@"退款成功"];
                    if (order.payType.intValue == 1) {
                        [refundTimeLineCell.applyDetail setText:@"支付宝处理成功后，退款会原路返回您的账户，请注意查收。"];
                    } else if(order.payType.intValue == 2) {
                        [refundTimeLineCell.applyDetail setText:@"微信支付处理成功后，退款会原路返回您的账户，请注意查收。"];
                    }
                    [refundTimeLineCell.bottomLine setHidden:YES];
                    break;
            }
            [self configCell:refundTimeLineCell row:indexPath.row];
            cell = refundTimeLineCell;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)configCell:(RefundTimeLineCell*)cell row:(NSInteger) row {
    Order *order = self.model.data;
    if(order.status.intValue == 5 ) {
        switch (row ) {
            case 1:
                break;
            case 2:
                cell.circle.backgroundColor = [UIColor lightGrayColor];
                cell.applyTitle.textColor = [UIColor lightGrayColor];
                cell.applyDetail.textColor = [UIColor lightGrayColor];
                break;
            case 3:
                cell.circle.backgroundColor = [UIColor lightGrayColor];
                cell.applyTitle.textColor = [UIColor lightGrayColor];
                cell.applyDetail.textColor = [UIColor lightGrayColor];
                break;
        }
    } else if (order.status.intValue == 7 ){
        switch (row ) {
            case 1:
                break;
            case 2:
                break;
            case 3:
                cell.circle.backgroundColor = [UIColor lightGrayColor];
                cell.applyTitle.textColor = [UIColor lightGrayColor];
                cell.applyDetail.textColor = [UIColor lightGrayColor];
                break;
        }
    } else if (order.status.intValue == 6 ){
        switch (row ) {
            case 1:
                break;
            case 2:
                break;
            case 3:
                break;
        }
    } else {
        cell.circle.backgroundColor = [UIColor lightGrayColor];
        cell.applyTitle.textColor = [UIColor lightGrayColor];
        cell.applyDetail.textColor = [UIColor lightGrayColor];
    }
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
                                 self.model = responseObject;
                                 [self.tableView reloadData];
                             }
     
                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 [self.view removeLoadingBee];
                                 [self showDialogWithTitle:nil message:error.message];
                             }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    if (indexPath.section == 0) {
        return 30;
    } else if(indexPath.row == 0) {
        return 44;
    } else if(indexPath.row == 1){
        return 60;
    }
    return 80;
}

- (UIEdgeInsets)separatorInsetForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        return UIEdgeInsetsMake(0,10,0,0);
    }
    return UIEdgeInsetsMake(0,SCREEN_WIDTH,0,0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
