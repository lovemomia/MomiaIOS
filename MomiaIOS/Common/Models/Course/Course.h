//
//  Course.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/13.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "JSONModel.h"

@interface CoursePlace : JSONModel
@property (nonatomic, strong) NSNumber *ids;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) CGFloat lng;
@property (nonatomic, assign) CGFloat lat;
@end

@interface CourseBook : JSONModel
@property (nonatomic, strong) NSArray *imgs;
@property (nonatomic, strong) NSArray *largeImgs;
@end

@interface Course : JSONModel

@property (nonatomic, strong) NSNumber *ids;
@property (nonatomic, strong) NSString<Optional> *cover;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSNumber *joined;
@property (nonatomic, strong) NSString *scheduler;
@property (nonatomic, strong) NSString *region;
@property (nonatomic, strong) NSString *subject;

@property (nonatomic, strong) NSArray<Optional> *imgs;
@property (nonatomic, strong) NSString<Optional> *goal;
@property (nonatomic, strong) CoursePlace<Optional> *place;
@property (nonatomic, strong) CourseBook<Optional> *book;


@end
