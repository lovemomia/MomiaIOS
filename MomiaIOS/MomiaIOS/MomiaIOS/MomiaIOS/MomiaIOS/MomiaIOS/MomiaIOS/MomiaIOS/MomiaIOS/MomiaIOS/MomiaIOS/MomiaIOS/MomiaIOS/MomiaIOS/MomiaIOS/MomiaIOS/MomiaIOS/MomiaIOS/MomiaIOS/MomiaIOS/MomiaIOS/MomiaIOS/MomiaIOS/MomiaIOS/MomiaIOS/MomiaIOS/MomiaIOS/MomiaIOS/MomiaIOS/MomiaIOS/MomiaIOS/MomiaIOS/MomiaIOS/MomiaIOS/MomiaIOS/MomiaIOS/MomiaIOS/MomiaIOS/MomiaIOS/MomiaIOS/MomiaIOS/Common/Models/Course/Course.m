//
//  Course.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/13.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "Course.h"

@implementation CoursePlace
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"ids"
                                                       }];
}
@end

@implementation CourseBook

@end

@implementation CourseDetailContent

@end

@implementation CourseDetail

@end

@implementation Course

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"ids"
                                                       }];
}

@end
