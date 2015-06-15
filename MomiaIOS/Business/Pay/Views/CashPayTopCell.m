//
//  CashPayTopCell.m
//  MomiaIOS
//
//  Created by Owen on 15/6/10.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "CashPayTopCell.h"

static NSString * identifier = @"CellCashPay";

@implementation CashPayTopCell

-(void)setData:(NSDictionary *) dic
{
    self.titleLabel.text = [dic objectForKey:@"title"];
    self.priceLabel.text = [dic objectForKey:@"price"];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
