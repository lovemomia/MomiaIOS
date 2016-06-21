//
//  OrderPerson.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/7.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "OrderPerson.h"

@implementation OrderPerson

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"opId"}];
}

@end
