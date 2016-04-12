//
//  IndexModel.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/13.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"
#import "CourseList.h"

@interface IndexBanner : JSONModel
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *action;
@end

@interface IndexIcon : JSONModel
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *action;
@end

@interface IndexEvent : JSONModel
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *action;
@end

@interface IndexSubject : JSONModel
@property (nonatomic, strong) NSNumber *ids;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString<Optional> *age;
@property (nonatomic, strong) NSNumber *joined;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, strong) NSNumber *subjectCourseType;
@property (nonatomic, strong) NSString *coursesTitle;
@property (nonatomic, strong) NSArray<Course> *courses;

@end

@interface IndexTopic : JSONModel
@property (nonatomic, strong) NSNumber *ids;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSNumber *joined;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;
@end

@protocol IndexBanner
@end

@protocol IndexIcon
@end

@protocol IndexEvent
@end

@protocol IndexSubject

@end

@protocol IndexTopic

@end

@interface IndexData : JSONModel
@property (nonatomic, strong) NSArray<IndexBanner> *banners;
@property (nonatomic, strong) NSString<Optional> *eventsTitle;
@property (nonatomic, strong) NSArray<IndexEvent> *events;
@property (nonatomic, strong) NSArray<IndexSubject> *subjects;
@property (nonatomic, strong) NSArray<IndexTopic, Optional> *topics;
@property (nonatomic, strong) CourseList *courses;
@end

@interface IndexModel : BaseModel
@property (nonatomic, strong) IndexData *data;
@end
