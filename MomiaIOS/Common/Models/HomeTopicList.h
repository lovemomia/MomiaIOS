//
//  HomeTopicList.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/8.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "JSONModel.h"

@protocol HomeTopic
@end

@interface HomeTopicList : JSONModel

@property (strong, nonatomic) NSArray<HomeTopic>* list;

@end
