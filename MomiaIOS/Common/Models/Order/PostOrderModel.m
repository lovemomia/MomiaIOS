//
//  PostOrderModel.m
//  MomiaIOS
//
//  Created by Owen on 15/6/30.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "PostOrderModel.h"

@implementation PostOrderDataModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"orderId"}];
}

@end

@implementation PostOrderModel

@end
