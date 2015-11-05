//
//  PackageDetailModel.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/13.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"
#import "Subject.h"
#import "CourseList.h"
#import "ReviewList.h"

@interface SubjectDetailData : JSONModel
@property (nonatomic, strong) Subject *subject;
@property (nonatomic, strong) CourseList *courses;
@property (nonatomic, strong) ReviewList *comments;
@end

@interface SubjectDetailModel : BaseModel
@property (nonatomic, strong) SubjectDetailData *data;
@end
