//
//  FeedDetailModel.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/9/17.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"
#import "Course.h"
#import "Feed.h"
#import "FeedComment.h"

@protocol FeedComment <NSObject>
@end

@interface FeedCommentList : JSONModel
@property (nonatomic, strong) NSArray<FeedComment, Optional> *list;
@property (nonatomic, strong) NSNumber<Optional> *nextIndex;
@property (nonatomic, strong) NSNumber<Optional> *totalCount;
@end

@interface FeedStar : JSONModel
@property (nonatomic, strong) NSNumber *ids;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *nickName;
@end

@protocol FeedStar <NSObject>
@end

@interface FeedStarList : JSONModel
@property (nonatomic, strong) NSArray<FeedStar, Optional> *list;
@property (nonatomic, strong) NSNumber<Optional> *totalCount;
@end

@interface FeedDetailData : JSONModel
@property (nonatomic, strong) FeedCommentList *comments;
@property (nonatomic, strong) Feed *feed;
@property (nonatomic, strong) Course<Optional> *course;
@property (nonatomic, strong) FeedStarList *staredUsers;
@end

@interface FeedDetailModel : BaseModel
@property (nonatomic, strong) FeedDetailData *data;
@end
