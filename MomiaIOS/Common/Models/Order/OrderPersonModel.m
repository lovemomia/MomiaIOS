//
//  OrderPersonModel.m
//  MomiaIOS
//
//  Created by Owen on 15/6/29.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "OrderPersonModel.h"

@implementation OrderPersonDataModel


+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"opId"}];
}

@end

@implementation OrderPersonModel

@end
