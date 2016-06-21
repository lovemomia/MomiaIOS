//
//  FeedTagListModel.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/11/9.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"

@interface FeedTag : JSONModel
@property (nonatomic, strong) NSNumber *ids;
@property (nonatomic, strong) NSString *name;
@end

@protocol FeedTag <NSObject>
@end

@interface FeedTagListData : JSONModel
@property (nonatomic, strong) NSArray<FeedTag> *recommendedTags;
@property (nonatomic, strong) NSArray<FeedTag> *hotTags;
@end

@interface FeedTagListModel : BaseModel
@property (nonatomic, strong) FeedTagListData *data;
@end
