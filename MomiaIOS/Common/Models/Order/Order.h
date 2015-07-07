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
@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, strong) NSString *participants;
@property (nonatomic, strong) NSNumber *productId;
@property (nonatomic, strong) NSNumber *skuId;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSNumber *totalFee;

@end
