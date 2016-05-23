//
//  OrderListItemCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/5.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "OrderListItemCell.h"
#import "PostOrderModel.h"

@interface OrderListItemCell()

@property (nonatomic, strong) Order *order;

@end

@implementation OrderListItemCell

- (void)awakeFromNib {
    // Initialization code
    self.iconTv.layer.masksToBounds = YES;
    self.iconTv.layer.cornerRadius = 3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onActionBtnClicked:(id)sender {
    
    if ([self.order.status intValue] == 2) {
        PostOrderModel *postOrder = [PostOrderModel new];
        
        PostOrderData *data = [PostOrderData new];
        data.orderId = [self.order.ids integerValue];
        data.count = [self.order.count integerValue];
        data.totalFee = [self.order.totalFee floatValue];
        
        postOrder.data = data;
        postOrder.errNo = 0;
        postOrder.errMsg = @"";
        postOrder.timestamp = 0;
        
        NSString *url = [NSString stringWithFormat:@"cashpay?pom=%@",
                         [[postOrder toJSONString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:MOURL_STRING(url)]];
        
    } else if ([self.order.status intValue] == 5 || [self.order.status intValue] == 6 || [self.order.status intValue] == 7 || [self.order.status intValue] == 8 || [self.order.status intValue] == 9){
        
        NSString *url = [NSString stringWithFormat:@"refunddetail?oid=%@",self.order.ids];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:MOURL_STRING(url)]];
        
    } else if (self.order.status.intValue == 3 ){
        
        NSString *url = [NSString stringWithFormat:@"applyrefund?oid=%@",self.order.ids];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:MOURL_STRING(url)]];
        
    }
}

- (void)setData:(Order *)order {
    self.order = order;
    [self.iconTv sd_setImageWithURL:[NSURL URLWithString:order.cover] placeholderImage:nil];
    self.titleLabel.text = order.title;
    self.priceLabel.text = [NSString stringWithFormat:@"价格：￥%@", order.totalFee];
    self.statusLabel.text = [self stringWithStatus:order];
    
    _amount.text = [NSString stringWithFormat:@"数量: %@",order.count];
    _totalFee.text = [NSString stringWithFormat:@"合计: ￥%@",order.totalFee];
    if ([order.status intValue] == 2) {
        _actionBtn.hidden = NO;
        [_actionBtn setTitle:@"付款" forState:UIControlStateNormal];
    } else if(order.status.intValue == 3 && order.canRefund.intValue == 1){
        _actionBtn.hidden = NO;
        [_actionBtn setTitle:@"退款" forState:UIControlStateNormal];
    } else if (order.status.intValue == 5 ){
        _actionBtn.hidden = NO;
        [_actionBtn setTitle:@"退款中" forState:UIControlStateNormal];
    } else if (order.status.intValue == 6 ) {
        _actionBtn.hidden = NO;
        [_actionBtn setTitle:@"已退款" forState:UIControlStateNormal];
    } else if (order.status.intValue == 7 ) {
        _actionBtn.hidden = NO;
        [_actionBtn setTitle:@"申请通过" forState:UIControlStateNormal];
    } else {
        _actionBtn.hidden = YES;
    }
}

- (NSString *)stringWithStatus:(Order *)order {
    
    if (order.status.intValue == 2) {
        return @"未付款";
    }
    switch (order.bookingStatus.intValue) {
        case 1:
            return @"待预约";
            break;
        case 2:
            return @"待上课";
            break;
        case 3:
            return @"已上课";
            break;
        default:
            break;
    }
    return @"未付款";
}

@end
