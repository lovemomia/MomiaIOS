//
//  GoodsTopicModel.h
//  MomiaIOS
//
//  Created by Owen on 15/5/21.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"


@interface GoodsTopicItem : JSONModel

@property (strong, nonatomic) NSString *abstracts;
@property (assign, nonatomic) int goodsId;
@property (strong, nonatomic) NSString *photo;
@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) float price;
@property (strong, nonatomic) NSString * userName;

@end

@protocol GoodsTopicItem
@end

@interface GoodsTopicData : JSONModel

@property (assign, nonatomic) int topicId;
@property (strong, nonatomic) NSString *topicPhoto;
@property (strong, nonatomic) NSString *topicTitle;
@property (strong, nonatomic) NSString *abstracts;
@property (assign, nonatomic) int favNum;
@property (assign, nonatomic) BOOL favStatus;
@property (strong, nonatomic) NSArray<GoodsTopicItem>* list;

@end

@interface GoodsTopicModel : BaseModel

@property (strong, nonatomic) GoodsTopicData *data;

@end

