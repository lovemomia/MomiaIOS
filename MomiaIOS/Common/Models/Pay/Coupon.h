//
//  Coupon.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/14.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "JSONModel.h"

@interface Coupon : JSONModel

@property (nonatomic, strong) NSNumber *ids; //消费时传这个参数
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSNumber *discount; //折扣数额
@property (nonatomic, strong) NSNumber *consumption; //最低消费额度
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger type; // 1、表示红包
@property (nonatomic, assign) NSInteger status;

@end
