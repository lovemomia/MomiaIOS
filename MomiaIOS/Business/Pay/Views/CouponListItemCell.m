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
    [self.statusBtn setBackgroundImage:[UIImage imageNamed:@"IconCouponTagGreen"] forState:UIControlStateNormal];
    [self.statusBtn setBackgroundImage:[UIImage imageNamed:@"IconCouponTagGray"] forState:UIControlStateDisabled];
    [self.statusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.statusBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateDisabled];
    self.statusBtn.titleLabel.transform = CGAffineTransformMakeRotation(M_PI * 1.0/4);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(Coupon *)coupon {
    self.discountLabel.text = [NSString stringWithFormat:@"￥%@", coupon.discount];
    self.titleLabel.text = coupon.title;
    self.descLabel.text = coupon.desc;
    self.timeLabel.text = [NSString stringWithFormat:@"%@至%@有效", coupon.startTime, coupon.endTime];
    if (coupon.status == 1) {
        self.statusBtn.enabled = YES;
    } else {
        self.statusBtn.enabled = NO;
    }
}

@end
