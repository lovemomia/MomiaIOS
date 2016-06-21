//
//  PackageDetailModel.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/13.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "SubjectDetailModel.h"

@implementation SubjectDetailData

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"subject": @"subject",
                                                       @"courses": @"courses",
                                                       @"comments": @"comments",
                                                       @"newCourses":@"freshCourses"
                                                       }];
}
@end

@implementation SubjectDetailModel

@end
