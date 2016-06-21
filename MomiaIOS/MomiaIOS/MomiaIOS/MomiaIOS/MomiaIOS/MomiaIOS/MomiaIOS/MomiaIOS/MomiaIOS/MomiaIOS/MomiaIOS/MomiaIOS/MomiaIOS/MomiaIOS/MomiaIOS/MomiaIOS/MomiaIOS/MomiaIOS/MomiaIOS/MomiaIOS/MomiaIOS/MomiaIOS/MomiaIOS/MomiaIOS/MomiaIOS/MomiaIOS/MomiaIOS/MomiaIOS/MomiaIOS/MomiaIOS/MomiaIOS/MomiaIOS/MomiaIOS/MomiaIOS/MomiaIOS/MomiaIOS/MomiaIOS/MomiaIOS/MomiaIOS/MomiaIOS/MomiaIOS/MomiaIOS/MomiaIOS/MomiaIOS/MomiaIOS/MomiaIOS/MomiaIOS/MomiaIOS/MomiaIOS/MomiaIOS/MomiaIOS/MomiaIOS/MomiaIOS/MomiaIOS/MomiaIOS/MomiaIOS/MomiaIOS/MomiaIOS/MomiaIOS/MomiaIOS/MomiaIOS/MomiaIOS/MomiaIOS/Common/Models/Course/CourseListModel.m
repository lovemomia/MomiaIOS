//
//  CourseListModel.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/19.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "CourseListModel.h"

@implementation Filter
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"ids"
                                                       }];
}
@end

@implementation CourseListData


@end

@implementation CourseListModel

@end
