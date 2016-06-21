//
//  FeedListModel.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/9/16.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"
#import "Feed.h"

@protocol Feed <NSObject>
@end

@interface FeedListData : JSONModel
@property (nonatomic, strong) NSArray<Feed> *list;
@property (nonatomic, strong) NSNumber *totalCount;
@property (nonatomic, strong) NSNumber<Optional> *nextIndex;
@end

@interface FeedListModel : BaseModel
@property (nonatomic, strong) FeedListData *data;
@end
