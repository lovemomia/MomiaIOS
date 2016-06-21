//
//  CouponListViewController.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/14.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableViewController.h"
#import "Coupon.h"

typedef void (^BlockSelectCoupon)(Coupon *coupon);

@interface CouponListViewController : MOTableViewController

@property (nonatomic, strong) BlockSelectCoupon selectCouponBlock;

@end
