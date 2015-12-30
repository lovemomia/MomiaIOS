//
//  ReviewList.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/11/5.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "JSONModel.h"

@interface ReviewChild : JSONModel
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *sex;
@end

@protocol ReviewChild <NSObject>
@end

@interface Review : JSONModel

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSArray<Optional> *children;
@property (nonatomic, strong) NSArray<Optional, ReviewChild> *childrenDetail;

@property (nonatomic, strong) NSNumber *star;
@property (nonatomic, strong) NSString *addTime;
@property (nonatomic, strong) NSString<Optional> *content;
@property (nonatomic, strong) NSArray<Optional> *imgs;
@property (nonatomic, strong) NSArray<Optional> *largeImgs;

@property (nonatomic, strong) NSNumber<Optional> *courseId;
@property (nonatomic, strong) NSString<Optional> *courseTitle;

@end

@protocol Review <NSObject>
@end

@interface ReviewList : JSONModel
@property (nonatomic, strong) NSArray<Review> *list;
@property (nonatomic, strong) NSNumber<Optional> *nextIndex;
@property (nonatomic, strong) NSNumber *totalCount;
@end
