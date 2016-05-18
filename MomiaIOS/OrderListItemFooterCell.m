//
//  OrderListItemFooterCell.m
//  MomiaIOS
//
//  Created by mosl on 16/5/4.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "OrderListItemFooterCell.h"
#import "PostOrderModel.h"

@implementation OrderListItemFooterCell

- (void)setData:(Order *)order{
 
    self.order = order;
    _amount.text = [NSString stringWithFormat:@"数量: %@",order.count];
    _totalFee.text = [NSString stringWithFormat:@"合计: ￥%@",order.totalFee];
    if ([order.status intValue] == 2) {
        [_actionBtn setTitle:@"付款" forState:UIControlStateNormal];
    } else if(order.status.intValue == 3 ){
        [_actionBtn setTitle:@"退款" forState:UIControlStateNormal];
    } else if (order.status.intValue == 5 ){
        [_actionBtn setTitle:@"退款申请" forState:UIControlStateNormal];
    } else if (order.status.intValue == 6 ) {
        [_actionBtn setTitle:@"已退款" forState:UIControlStateNormal];
    } else if (order.status.intValue == 7 ) {
        [_actionBtn setTitle:@"申请通过" forState:UIControlStateNormal];
    } else {
        _actionBtn.hidden = YES;
        _backGroundView.hidden = YES;
    }
}

- (IBAction)actionBtnPressed:(id)sender {
    
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

@end
