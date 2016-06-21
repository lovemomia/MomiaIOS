//
//  MySuggestModel.h
//  MomiaIOS
//
//  Created by Owen on 15/5/29.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"

@interface MysuggestItem : JSONModel
@property(nonatomic,assign) NSInteger sId;
@property(nonatomic,strong) NSString * picUrl;
@property(nonatomic,strong) NSString * time;
@property(nonatomic,strong) NSString * title;
@property(nonatomic,strong) NSArray * assortments;

@end

@protocol MysuggestItem

@end

@interface MySuggestData : JSONModel

@property(nonatomic,strong) NSArray<MysuggestItem> * goodsList;

@end

@interface MySuggestModel : BaseModel

@property(nonatomic,strong) MySuggestData * data;

@end
