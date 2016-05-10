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
        
        NSString *url = [NSString stringWithFormat:@"cashpay?pom=%@",
                                           [[order toJSONString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:MOURL_STRING(url)]];
        
    } else if ([self.order.bookingStatus intValue] == 1) {
        NSString *url = [NSString stringWithFormat:@"bookingsubjectlist?oid=%@", self.order.ids];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:MOURL_STRING(url)]];
    }
}

- (void)setData:(Order *)order {
    self.order = order;
    [self.iconTv sd_setImageWithURL:[NSURL URLWithString:order.cover] placeholderImage:nil];
    self.titleLabel.text = order.title;
    self.priceLabel.text = [NSString stringWithFormat:@"价格：￥%@", order.totalFee];
//    self.countLabel.text = [NSString stringWithFormat:@"数量：%@", order.count];
    self.statusLabel.text = [self stringWithStatus:order];
}

- (NSString *)stringWithStatus:(Order *)order {
    return @"每次任选三次课，1大1小参加";
}

@end
