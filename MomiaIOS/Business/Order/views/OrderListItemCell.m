//
//  OrderListItemCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/5.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "OrderListItemCell.h"

@implementation OrderListItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(Order *)order {
    self.titleLabel.text = order.title;
    self.priceLabel.text = [NSString stringWithFormat:@"总价：￥%@", order.totalFee];
    self.peopleLabel.text = [NSString stringWithFormat:@"人数：%@", order.participants];
}

@end
