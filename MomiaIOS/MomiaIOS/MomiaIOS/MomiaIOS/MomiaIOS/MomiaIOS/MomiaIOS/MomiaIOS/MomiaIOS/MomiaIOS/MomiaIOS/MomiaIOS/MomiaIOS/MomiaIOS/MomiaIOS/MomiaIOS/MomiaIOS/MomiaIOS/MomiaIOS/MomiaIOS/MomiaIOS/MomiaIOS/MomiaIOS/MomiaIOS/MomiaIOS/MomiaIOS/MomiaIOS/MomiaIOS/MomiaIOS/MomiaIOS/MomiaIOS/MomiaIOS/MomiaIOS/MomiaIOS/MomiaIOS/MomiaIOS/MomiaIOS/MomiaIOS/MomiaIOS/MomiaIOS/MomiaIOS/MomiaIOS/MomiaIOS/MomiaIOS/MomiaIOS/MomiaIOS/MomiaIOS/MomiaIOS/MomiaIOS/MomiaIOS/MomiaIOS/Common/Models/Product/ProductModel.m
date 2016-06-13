//
//  ProductItemModel.m
//  MomiaIOS
//
//  Created by Owen on 15/6/17.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ProductModel.h"


@implementation ProductBodyModel


@end

@implementation ProductContentModel


@end

@implementation ProductCustomersModel


@end



@implementation ProductModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"pID"
                                                       }];
}

@end
