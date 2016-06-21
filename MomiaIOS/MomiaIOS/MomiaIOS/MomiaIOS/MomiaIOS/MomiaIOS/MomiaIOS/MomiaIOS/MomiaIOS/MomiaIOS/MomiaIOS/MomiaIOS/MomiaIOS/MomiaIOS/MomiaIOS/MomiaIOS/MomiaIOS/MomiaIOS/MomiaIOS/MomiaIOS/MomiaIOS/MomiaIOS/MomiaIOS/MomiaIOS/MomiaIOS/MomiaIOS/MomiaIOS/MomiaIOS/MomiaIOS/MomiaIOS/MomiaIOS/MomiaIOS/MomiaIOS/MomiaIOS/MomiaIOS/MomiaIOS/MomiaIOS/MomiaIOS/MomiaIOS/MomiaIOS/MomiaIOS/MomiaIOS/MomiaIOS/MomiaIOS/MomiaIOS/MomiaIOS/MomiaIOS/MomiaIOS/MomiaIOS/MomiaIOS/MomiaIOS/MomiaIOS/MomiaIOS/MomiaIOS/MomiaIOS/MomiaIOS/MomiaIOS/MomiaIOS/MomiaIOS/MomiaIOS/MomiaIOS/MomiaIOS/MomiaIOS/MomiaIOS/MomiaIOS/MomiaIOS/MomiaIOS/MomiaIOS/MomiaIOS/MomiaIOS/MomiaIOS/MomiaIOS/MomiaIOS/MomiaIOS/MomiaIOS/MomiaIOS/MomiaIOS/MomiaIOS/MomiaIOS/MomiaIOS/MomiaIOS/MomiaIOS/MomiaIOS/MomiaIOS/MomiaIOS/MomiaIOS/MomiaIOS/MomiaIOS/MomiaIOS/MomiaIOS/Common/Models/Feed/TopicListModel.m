//
//  TopicListModel.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/9/24.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "TopicListModel.h"

@implementation Topic
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"ids"
                                                       }];
}
@end

@implementation TopicListData

@end

@implementation TopicListModel

@end
