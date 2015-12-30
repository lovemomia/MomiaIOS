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
//#import "FeedListModel.h"

@interface SubjectDetailData : JSONModel
@property (nonatomic, strong) Subject *subject;
@property (nonatomic, strong) CourseList *courses;
@property (nonatomic, strong) ReviewList<Optional> *comments;
//@property (nonatomic, strong) FeedListData<Optional> *feeds;
@end

@interface SubjectDetailModel : BaseModel
@property (nonatomic, strong) SubjectDetailData *data;
@end
