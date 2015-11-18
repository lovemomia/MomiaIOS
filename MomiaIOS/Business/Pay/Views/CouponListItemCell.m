//
//  CouponListItemCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/14.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "CouponListItemCell.h"

@implementation CouponListItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(Coupon *)coupon {
    self.discountLabel.text = [NSString stringWithFormat:@"%@", coupon.discount];
    self.descLabel.text = [NSString stringWithFormat:@"使用说明：%@", coupon.desc];
    self.timeLabel.text = [NSString stringWithFormat:@"有效期：%@", coupon.endTime];
    if (coupon.status == 1) {
        self.statusIv.hidden = YES;
        self.backIv.image = [UIImage imageNamed:@"BgCouponGreen"];
        self.discountLabel.textColor = UIColorFromRGB(0x50D1B7);
        self.yuanLabel.textColor = UIColorFromRGB(0x50D1B7);
        
    } else if (coupon.status == 2) { // 已使用
        self.statusIv.hidden = NO;
        self.backIv.image = [UIImage imageNamed:@"BgCouponGray"];
        self.statusIv.image = [UIImage imageNamed:@"IconCouponUsed"];
        self.discountLabel.textColor = UIColorFromRGB(0x999999);
        self.yuanLabel.textColor = UIColorFromRGB(0x999999);
        
    } else { // 已过期
        self.statusIv.hidden = NO;
        self.backIv.image = [UIImage imageNamed:@"BgCouponGray"];
        self.statusIv.image = [UIImage imageNamed:@"IconCouponExpired"];
        self.discountLabel.textColor = UIColorFromRGB(0x999999);
        self.yuanLabel.textColor = UIColorFromRGB(0x999999);
        
        
    }
}

@end
