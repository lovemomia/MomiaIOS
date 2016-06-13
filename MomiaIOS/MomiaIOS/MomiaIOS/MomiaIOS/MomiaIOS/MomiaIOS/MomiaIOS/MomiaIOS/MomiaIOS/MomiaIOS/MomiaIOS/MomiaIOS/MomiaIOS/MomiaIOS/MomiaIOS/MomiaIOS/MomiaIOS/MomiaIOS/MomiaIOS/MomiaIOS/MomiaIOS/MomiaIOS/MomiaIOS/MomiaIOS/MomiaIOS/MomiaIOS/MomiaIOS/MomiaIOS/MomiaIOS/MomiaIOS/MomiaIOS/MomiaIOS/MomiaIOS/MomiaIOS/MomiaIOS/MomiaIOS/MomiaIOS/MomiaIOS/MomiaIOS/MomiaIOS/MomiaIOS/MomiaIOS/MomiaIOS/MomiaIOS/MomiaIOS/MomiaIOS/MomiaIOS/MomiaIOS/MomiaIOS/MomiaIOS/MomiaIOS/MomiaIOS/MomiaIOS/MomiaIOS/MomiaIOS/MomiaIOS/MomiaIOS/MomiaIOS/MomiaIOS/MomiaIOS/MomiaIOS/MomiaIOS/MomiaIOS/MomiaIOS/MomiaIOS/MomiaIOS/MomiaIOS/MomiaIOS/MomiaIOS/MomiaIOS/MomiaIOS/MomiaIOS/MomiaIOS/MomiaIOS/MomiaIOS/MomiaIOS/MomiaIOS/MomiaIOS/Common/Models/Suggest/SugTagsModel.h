//
//  SugTagsModel.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/21.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"

@interface Tag : JSONModel

@property (assign, nonatomic) int pairID;
@property (strong, nonatomic) NSString* name;
@property (assign, nonatomic) BOOL isSelected;

@end

@protocol Tag
@end

@interface SugTagsData : JSONModel

@property (strong, nonatomic) NSArray<Tag>* assorts;
@property (strong, nonatomic) NSArray<Tag>* crowds;

@end

@interface SugTagsModel : BaseModel

@property (strong, nonatomic) SugTagsData* data;

@end
