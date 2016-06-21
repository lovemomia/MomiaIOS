//
//  Coupon.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/14.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "Coupon.h"

@implementation Coupon

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"ids"
                                                       }];
}

@end
