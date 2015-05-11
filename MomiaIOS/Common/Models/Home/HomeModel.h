//
//  HomeModel.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/8.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"

@interface HomeTopic : JSONModel

@property (assign, nonatomic) int type;
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* photo;
@property (strong, nonatomic) NSString* action;

@end

@protocol HomeTopic
@end

@interface HomeTopicList : JSONModel

@property (strong, nonatomic) NSArray<HomeTopic>* list;

@end

@interface HomeModel : BaseModel

@property (strong, nonatomic) HomeTopicList *data;

@end
