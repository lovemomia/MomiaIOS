//
//  PackageDetailModel.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/13.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"

@class Package;
@class CourseList;

@interface PackageDetailData : JSONModel
@property (nonatomic, strong) Package *subject;
@property (nonatomic, strong) CourseList *courses;
@end

@interface PackageDetailModel : BaseModel
@property (nonatomic, strong) PackageDetailData *data;
@end
