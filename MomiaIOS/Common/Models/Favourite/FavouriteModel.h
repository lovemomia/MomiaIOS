//
//  FavouriteModel.h
//  MomiaIOS
//
//  Created by Owen on 15/5/29.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"

@interface FavouriteItem : JSONModel

@property(nonatomic,assign) NSInteger favoriteId;
@property(nonatomic,strong) NSString * picUrl;
@property(nonatomic,assign) NSInteger refId;
@property(nonatomic,strong) NSString * time;
@property(nonatomic,strong) NSString * title;
@property(nonatomic,assign) NSInteger type;

@end

@protocol FavouriteItem

@end

@interface FavouriteData : JSONModel

@property(nonatomic,strong) NSArray<FavouriteItem> * favoriteList;

@end

@interface FavouriteModel : BaseModel

@property(nonatomic,strong) FavouriteData * data;

@end
