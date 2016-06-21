//
//  MySuggestModel.m
//  MomiaIOS
//
//  Created by Owen on 15/5/29.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MySuggestModel.h"
@implementation MysuggestItem

#pragma mark -
#pragma mark keyMapper

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"sId"
                                                       }];
}


@end

@implementation MySuggestData

@end

@implementation MySuggestModel

@end
