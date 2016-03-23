//
//  IndexModel.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/13.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "IndexModel.h"

@implementation IndexBanner

@end

@implementation IndexIcon

@end

@implementation IndexEvent

@end

@implementation IndexSubject

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"ids"
                                                       }];
}

@end

@implementation IndexTopic

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"ids"
                                                       }];
}

@end

@implementation IndexData

@end

@implementation IndexModel

@end
