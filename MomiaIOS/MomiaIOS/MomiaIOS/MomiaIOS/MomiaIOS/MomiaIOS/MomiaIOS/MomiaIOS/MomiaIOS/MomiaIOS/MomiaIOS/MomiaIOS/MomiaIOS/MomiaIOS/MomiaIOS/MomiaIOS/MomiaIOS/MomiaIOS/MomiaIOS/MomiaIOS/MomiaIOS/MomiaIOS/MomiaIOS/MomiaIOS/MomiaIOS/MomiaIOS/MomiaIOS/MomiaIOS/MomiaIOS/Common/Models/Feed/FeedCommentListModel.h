//
//  FeedCommentListModel.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/9/22.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"
#import "FeedComment.h"

@protocol FeedComment
@end

@interface FeedCommentListData : JSONModel

@property(nonatomic,strong) NSArray<FeedComment> * list;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, strong) NSNumber<Optional> *nextIndex;

@end

@interface FeedCommentListModel : BaseModel
@property (nonatomic, strong) FeedCommentListData *data;
@end
