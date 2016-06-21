//
//  LeaderStatusModel.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/8/3.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"

@interface LeaderStatusDescContentBody : JSONModel
@property (nonatomic, strong) NSString *text;
@end

@protocol LeaderStatusDescContentBody <NSObject>
@end

@interface LeaderStatusDescContent : JSONModel
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray<LeaderStatusDescContentBody> *body;
@end

@protocol LeaderStatusDescContent <NSObject>
@end

@interface LeaderStatusDesc : JSONModel
@property (nonatomic, strong) NSArray<LeaderStatusDescContent> *content;
@end

@protocol ProductModel
@end

@interface LeaderStatusProducts : JSONModel
@property(nonatomic,strong) NSArray<ProductModel> * list;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, strong) NSNumber<Optional> *nextIndex;
@end

@interface LeaderStatusData : JSONModel
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) LeaderStatusDesc<Optional> *desc; //还未申请时的介绍文案
@property (nonatomic, strong) LeaderStatusProducts<Optional> *products; //审核通过后展示已成为领队列表
@property (nonatomic, strong) NSString<Optional> *msg; //审核未通过时显示
@end

@interface LeaderStatusModel : BaseModel
@property (nonatomic, strong) LeaderStatusData *data;
@end
