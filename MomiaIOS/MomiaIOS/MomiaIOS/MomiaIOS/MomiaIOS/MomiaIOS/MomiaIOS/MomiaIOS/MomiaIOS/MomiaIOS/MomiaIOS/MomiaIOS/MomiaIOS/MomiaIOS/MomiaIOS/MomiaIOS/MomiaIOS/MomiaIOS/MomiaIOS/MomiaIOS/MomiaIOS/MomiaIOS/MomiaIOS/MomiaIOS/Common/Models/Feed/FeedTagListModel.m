//
//  FeedTagListModel.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/11/9.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "FeedTagListModel.h"

@implementation FeedTag

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"ids"
                                                       }];
}

@end

@implementation FeedTagListData

@end

@implementation FeedTagListModel

@end
