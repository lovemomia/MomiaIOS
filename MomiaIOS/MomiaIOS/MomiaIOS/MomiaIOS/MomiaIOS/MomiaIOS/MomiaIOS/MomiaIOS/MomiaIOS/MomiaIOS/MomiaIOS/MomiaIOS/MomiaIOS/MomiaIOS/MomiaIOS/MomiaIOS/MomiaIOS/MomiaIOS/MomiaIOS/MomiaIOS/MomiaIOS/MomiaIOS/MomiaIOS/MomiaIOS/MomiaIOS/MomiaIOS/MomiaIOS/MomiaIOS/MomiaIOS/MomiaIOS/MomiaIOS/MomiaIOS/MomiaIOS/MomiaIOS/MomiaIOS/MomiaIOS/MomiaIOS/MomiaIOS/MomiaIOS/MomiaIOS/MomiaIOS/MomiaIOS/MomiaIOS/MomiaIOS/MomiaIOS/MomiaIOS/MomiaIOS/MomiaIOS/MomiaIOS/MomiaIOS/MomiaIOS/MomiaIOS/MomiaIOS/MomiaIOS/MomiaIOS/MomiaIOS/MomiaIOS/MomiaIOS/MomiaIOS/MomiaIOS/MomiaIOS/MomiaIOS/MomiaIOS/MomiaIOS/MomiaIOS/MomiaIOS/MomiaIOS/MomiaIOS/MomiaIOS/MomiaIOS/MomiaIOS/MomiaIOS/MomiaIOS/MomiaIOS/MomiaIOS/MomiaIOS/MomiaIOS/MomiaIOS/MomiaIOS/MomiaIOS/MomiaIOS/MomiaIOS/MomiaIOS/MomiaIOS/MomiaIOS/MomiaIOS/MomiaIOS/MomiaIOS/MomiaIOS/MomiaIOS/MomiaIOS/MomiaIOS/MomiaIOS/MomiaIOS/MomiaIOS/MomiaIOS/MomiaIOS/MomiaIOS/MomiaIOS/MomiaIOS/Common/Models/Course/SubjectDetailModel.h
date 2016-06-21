//
//  PackageDetailModel.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/13.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"
#import "Subject.h"
#import "Course.h"
#import "ReviewList.h"
//#import "FeedListModel.h"

@protocol Course
@end

@interface SubjectDetailData : JSONModel
@property (nonatomic, strong) Subject *subject;
@property (nonatomic, strong) NSArray<Optional,Course> *courses;
@property (nonatomic, strong) ReviewList<Optional> *comments;
@property (nonatomic, strong) NSArray<Optional,Course> *freshCourses;
//@property (nonatomic, strong) FeedListData<Optional> *feeds;
@end


@interface SubjectDetailModel : BaseModel
@property (nonatomic, strong) SubjectDetailData *data;
@end
