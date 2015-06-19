//
//  BaseModel.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/8.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

#pragma mark -
#pragma mark keyMapper

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"errno":@"errNo",
                                                       @"errmsg":@"errMsg",
                                                       @"time":@"timestamp"
                                                       }];
}

@end
