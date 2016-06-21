//
//  UserTimelineModel.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/12/22.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"
#import "User.h"
#import "ReviewList.h"

@interface UserTimelineItem : JSONModel
@property (nonatomic, strong) NSNumber *courseId;
@property (nonatomic, strong) NSString *courseTitle;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) Review<Optional> *comment;
@end

@protocol UserTimelineItem <NSObject>
@end

@interface UserTimeline : JSONModel
@property (nonatomic, strong) NSArray<UserTimelineItem, Optional> *list;
@property (nonatomic, strong) NSNumber *totalCount;
@property (nonatomic, strong) NSNumber<Optional> *nextIndex;
@end

@interface UserTimelineData : JSONModel
@property (nonatomic, strong) User<Optional> *user;
@property (nonatomic, strong) UserTimeline *timeline;
@end

@interface UserTimelineModel : BaseModel
@property (nonatomic, strong) UserTimelineData *data;
@end
