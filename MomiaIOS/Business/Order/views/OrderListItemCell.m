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
        PostOrderModel *order = [PostOrderModel new];
        
        PostOrderData *data = [PostOrderData new];
        data.orderId = [self.order.ids integerValue];
        data.count = [self.order.count integerValue];
        data.totalFee = [self.order.totalFee floatValue];
        
        order.data = data;
        order.errNo = 0;
        order.errMsg = @"";
        order.timestamp = 0;
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"duola://cashpay?pom=%@",
                                           [[order toJSONString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        [[UIApplication sharedApplication] openURL:url];
        
    } else if ([self.order.bookingStatus intValue] == 1) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"duola://bookingsubjectlist?oid=%@", self.order.ids]]];
    }
}

- (void)setData:(Order *)order {
    self.order = order;
    [self.iconTv sd_setImageWithURL:[NSURL URLWithString:order.cover] placeholderImage:nil];
    self.titleLabel.text = order.title;
    self.priceLabel.text = [NSString stringWithFormat:@"总价：￥%@", order.totalFee];
    self.countLabel.text = [NSString stringWithFormat:@"数量：%@", order.count];
    self.statusLabel.text = [self stringWithStatus:order];
    
    if ([order.status intValue] == 2) {
        self.actionBtn.hidden = NO;
        [self.actionBtn setTitle:@"付款" forState:UIControlStateNormal];
    } else if ([order.bookingStatus intValue] == 1) {
        self.actionBtn.hidden = NO;
        [self.actionBtn setTitle:@"预约" forState:UIControlStateNormal];
    } else {
        self.actionBtn.hidden = YES;
    }
}

- (NSString *)stringWithStatus:(Order *)order {
    int st = [order.status intValue];
    if (st == 2) {
        return @"未付款";
    }
    
    st = [order.bookingStatus intValue];
    if (st == 1) {
        return @"待预约";
    } else if (st == 2) {
        return @"待上课";
    } else if (st == 3) {
        return @"已上课";
    }
    return @"未付款";
}

@end
