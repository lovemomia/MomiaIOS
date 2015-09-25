//
//  Feed.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/9/16.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "JSONModel.h"

@interface Feed : JSONModel

@property (nonatomic, strong) NSNumber *ids;
@property (nonatomic, strong) NSString *addTime;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *poi;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSArray *imgs;
@property (nonatomic, strong) NSArray<Optional> *children;
@property (nonatomic, strong) NSNumber *type;

// ugc
@property (nonatomic, strong) NSNumber *commentCount;
@property (nonatomic, strong) NSNumber *starCount;
@property (nonatomic, strong) NSNumber *stared;

// topic
@property (nonatomic, strong) NSString *topic;
@property (nonatomic, strong) NSNumber *topicId;
@property (nonatomic, strong) NSNumber *topicType;
@property (nonatomic, strong) NSNumber *refId;



@end
