//
//  Feed.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/9/16.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "Feed.h"

@implementation Feed

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"ids"
                                                       }];
}

@end
