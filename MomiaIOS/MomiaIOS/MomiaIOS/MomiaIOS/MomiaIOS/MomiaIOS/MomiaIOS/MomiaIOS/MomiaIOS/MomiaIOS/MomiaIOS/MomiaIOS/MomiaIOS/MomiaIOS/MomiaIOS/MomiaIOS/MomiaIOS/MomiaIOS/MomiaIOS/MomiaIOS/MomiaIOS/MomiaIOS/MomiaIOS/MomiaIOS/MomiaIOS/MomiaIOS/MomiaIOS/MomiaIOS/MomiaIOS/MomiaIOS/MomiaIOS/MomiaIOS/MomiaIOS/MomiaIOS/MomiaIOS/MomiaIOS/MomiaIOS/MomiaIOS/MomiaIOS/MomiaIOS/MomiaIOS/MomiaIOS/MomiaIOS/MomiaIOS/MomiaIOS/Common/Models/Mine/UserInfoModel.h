//
//  UserInfoModel.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/11/13.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"
#import "Feed.h"
#import "User.h"

@protocol Feed <NSObject>
@end

@interface FeedList : JSONModel
@property (nonatomic, strong) NSArray<Feed> *list;
@property (nonatomic, strong) NSNumber *totalCount;
@property (nonatomic, strong) NSNumber<Optional> *nextIndex;
@end

@interface UserInfoData : JSONModel
@property (nonatomic, strong) FeedList *feeds;
@property (nonatomic, strong) User<Optional> *user;
@end

@interface UserInfoModel : BaseModel
@property (nonatomic, strong) UserInfoData *data;
@end
