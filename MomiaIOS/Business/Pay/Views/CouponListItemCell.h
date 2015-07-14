//
//  CouponListItemCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/14.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coupon.h"

@interface CouponListItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;


- (void)setData:(Coupon *)coupon;

@end
