//
//  ReviewList.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/11/5.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "JSONModel.h"

@interface Review : JSONModel

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSArray *children;

@property (nonatomic, strong) NSNumber *star;
@property (nonatomic, strong) NSString *addTime;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSArray *imgs;
@property (nonatomic, strong) NSArray *largeImgs;

@end

@protocol Review <NSObject>
@end

@interface ReviewList : JSONModel
@property (nonatomic, strong) NSArray<Review> *list;
@property (nonatomic, strong) NSNumber<Optional> *nextIndex;
@property (nonatomic, strong) NSNumber *totalCount;
@end
