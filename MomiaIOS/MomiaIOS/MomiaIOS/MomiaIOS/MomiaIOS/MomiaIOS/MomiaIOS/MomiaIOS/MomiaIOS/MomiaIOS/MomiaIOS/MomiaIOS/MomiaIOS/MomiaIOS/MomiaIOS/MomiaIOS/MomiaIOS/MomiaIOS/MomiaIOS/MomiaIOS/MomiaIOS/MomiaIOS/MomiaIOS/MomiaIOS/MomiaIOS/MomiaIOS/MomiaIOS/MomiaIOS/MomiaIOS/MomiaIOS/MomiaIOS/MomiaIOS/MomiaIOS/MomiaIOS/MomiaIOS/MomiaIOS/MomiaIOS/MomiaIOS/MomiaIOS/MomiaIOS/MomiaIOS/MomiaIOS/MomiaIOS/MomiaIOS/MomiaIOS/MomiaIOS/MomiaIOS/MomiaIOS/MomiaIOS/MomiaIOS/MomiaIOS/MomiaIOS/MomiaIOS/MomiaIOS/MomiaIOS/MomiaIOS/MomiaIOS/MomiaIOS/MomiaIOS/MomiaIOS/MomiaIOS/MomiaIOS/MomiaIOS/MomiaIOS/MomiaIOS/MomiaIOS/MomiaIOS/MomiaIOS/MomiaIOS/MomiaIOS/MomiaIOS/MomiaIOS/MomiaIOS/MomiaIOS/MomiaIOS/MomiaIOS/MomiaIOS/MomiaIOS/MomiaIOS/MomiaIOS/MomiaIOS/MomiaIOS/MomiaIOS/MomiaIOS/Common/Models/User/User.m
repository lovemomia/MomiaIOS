//
//  User.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/11/13.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "User.h"

@implementation User

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"uid"
                                                       }];
}

@end
