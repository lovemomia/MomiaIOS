//
//  Coupon.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/14.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "JSONModel.h"

@interface Coupon : JSONModel

@property (nonatomic, strong) NSNumber *ids;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSNumber *discount;
@property (nonatomic, strong) NSNumber *consumption;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger status;

@end
