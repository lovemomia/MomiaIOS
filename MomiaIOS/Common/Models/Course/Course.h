//
//  Course.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/13.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "JSONModel.h"
#import "HomeworkList.h"
#import "CourseCommentList.h"

@interface CoursePlace : JSONModel
@property (nonatomic, strong) NSNumber *ids;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) CGFloat lng;
@property (nonatomic, assign) CGFloat lat;
@property (nonatomic, strong) NSString<Optional> *scheduler;
@end

@interface CourseBook : JSONModel
@property (nonatomic, strong) NSArray *imgs;
@property (nonatomic, strong) NSArray *largeImgs;
@end

@interface CourseTeacher : JSONModel
@property (nonatomic, strong) NSString *avatar;
@end

@protocol CourseTeacher
@end

@interface Course : JSONModel

@property (nonatomic, strong) NSNumber *ids;
@property (nonatomic, strong) NSString<Optional> *cover; //封面
@property (nonatomic, strong) NSString *title; //标题
@property (nonatomic, assign) CGFloat price; //价格
@property (nonatomic, strong) NSString *age; //年龄
@property (nonatomic, strong) NSNumber *joined; //参加人数
@property (nonatomic, strong) NSString<Optional> *scheduler; //场次日期
@property (nonatomic, strong) NSString *region; //地区
@property (nonatomic, strong) NSNumber<Optional> *insurance; //红包

@property (nonatomic, strong) NSArray<Optional> *imgs; //头图
@property (nonatomic, strong) NSString<Optional> *goal;  //课程目标
@property (nonatomic, strong) CoursePlace<Optional> *place;  //上课地点
@property (nonatomic, strong) CourseBook<Optional> *book;  //课前绘本
@property (nonatomic, strong) NSString<Optional> *flow;  //课程内容

@property (nonatomic, strong) HomeworkList<Optional> *homework;
@property (nonatomic, strong) CourseCommentList<Optional> *comments;
@property (nonatomic, strong) NSArray<CourseTeacher, Optional> *teachers;
@property (nonatomic, strong) NSString<Optional> *tips; //提示
@property (nonatomic, strong) NSString<Optional> *institution; //合作机构

@end
