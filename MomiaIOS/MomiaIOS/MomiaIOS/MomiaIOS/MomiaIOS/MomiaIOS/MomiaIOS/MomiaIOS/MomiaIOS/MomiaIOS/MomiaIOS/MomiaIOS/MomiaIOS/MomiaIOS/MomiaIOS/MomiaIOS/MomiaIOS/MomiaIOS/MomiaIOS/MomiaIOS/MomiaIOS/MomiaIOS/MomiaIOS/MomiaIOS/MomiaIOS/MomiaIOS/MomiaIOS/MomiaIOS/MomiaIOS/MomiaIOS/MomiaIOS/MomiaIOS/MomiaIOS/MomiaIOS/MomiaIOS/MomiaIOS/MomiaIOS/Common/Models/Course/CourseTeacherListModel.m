//
//  CourseTeacherListModel.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/22.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "CourseTeacherListModel.h"

@implementation CourseTeacher
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"ids"
                                                       }];
}
@end

@implementation CourseTeacherListData

@end

@implementation CourseTeacherListModel

@end
