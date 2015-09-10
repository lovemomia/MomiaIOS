//
//  FillOrderModel.m
//  MomiaIOS
//
//  Created by Owen on 15/6/26.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "FillOrderModel.h"

@implementation FillOrderPriceModel

@end

@implementation FillOrderSkuModel

@end

@implementation FillOrderContactsModel

@end

@implementation FillOrderPlaceModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"ids"
                                                       }];
}

@end

@implementation FillOrderDataModel

@end

@implementation FillOrderModel

@end
