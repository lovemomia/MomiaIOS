//
//  Order.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/5.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : JSONModel

@property (nonatomic, strong) NSNumber *ids;
@property (nonatomic, strong) NSNumber *subjectId;
@property (nonatomic, strong) NSNumber<Optional> *courseId;

@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, strong) NSNumber *totalFee;
@property (nonatomic, strong) NSNumber *status; // 2未支付 3已付款 4已使用 5待退款 6已退款
@property (nonatomic, strong) NSNumber *bookingStatus; // 1 待预约，2 待上课，3 已上课

@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *addTime;
@property (nonatomic, strong) NSString<Optional> *cover;
@property (nonatomic, strong) NSString<Optional>* couponDesc;


@end
