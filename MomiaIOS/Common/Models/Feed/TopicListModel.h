//
//  TopicListModel.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/9/24.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"

@interface Topic : JSONModel
@property (nonatomic, strong) NSNumber *ids;
@property (nonatomic, strong) NSNumber *productId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *scheduler;
@property (nonatomic, strong) NSString *region;
@end

@protocol Topic <NSObject>
@end

@interface TopicListData : JSONModel
@property (nonatomic, strong) NSArray<Topic> *list;
@property (nonatomic, strong) NSNumber *totalCount;
@property (nonatomic, strong) NSNumber<Optional> *nextIndex;
@end

@interface TopicListModel : BaseModel
@property (nonatomic, strong) TopicListData *data;
@end
