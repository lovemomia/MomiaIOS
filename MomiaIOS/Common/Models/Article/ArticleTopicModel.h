//
//  ArticleTopicModel.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/10.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"

@interface ArticleTopicItem : JSONModel

@property (strong, nonatomic) NSString *abstracts;
@property (assign, nonatomic) int articleId;
@property (strong, nonatomic) NSString *photo;
@property (strong, nonatomic) NSString *title;

@end

@protocol ArticleTopicItem
@end

@interface ArticleTopicData : JSONModel

@property (assign, nonatomic) int topicId;
@property (strong, nonatomic) NSString *topicPhoto;
@property (strong, nonatomic) NSString *topicTitle;
@property (strong, nonatomic) NSString *abstracts;
@property (assign, nonatomic) int favNum;
@property (assign, nonatomic) BOOL favStatus;
@property (strong, nonatomic) NSArray<ArticleTopicItem>* list;

@end

@interface ArticleTopicModel : BaseModel

@property (strong, nonatomic) ArticleTopicData *data;

@end
