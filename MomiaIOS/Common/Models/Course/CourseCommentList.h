//
//  CourseCommentList.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/14.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "JSONModel.h"

@interface CourseComment : JSONModel
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSArray *children;
@property (nonatomic, strong) NSNumber *addTime;
@property (nonatomic, strong) NSNumber *content;
@property (nonatomic, strong) NSArray *imgs;
@property (nonatomic, strong) NSArray *largeImgs;
@property (nonatomic, strong) NSNumber *star;
@end

@protocol CourseComment <NSObject>
@end

@interface CourseCommentList : JSONModel
@property (nonatomic, strong) NSArray<CourseComment> *list;
@property (nonatomic, strong) NSNumber<Optional> *nextIndex;
@property (nonatomic, strong) NSNumber *totalCount;
@end
