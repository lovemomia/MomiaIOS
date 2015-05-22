//
//  GoodsDetailModel.h
//  MomiaIOS
//
//  Created by Owen on 15/5/21.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"


@interface GoodsDetailImgItem : JSONModel

@property(nonatomic,assign) int width;
@property(nonatomic,assign) int height;
@property(nonatomic,strong) NSString * url;

@end

@protocol GoodsDetailImgItem
@end

@interface GoodsDetailShopItem : JSONModel

@property(nonatomic,strong) NSString * desc;
@property(nonatomic,strong) NSString * name;
@property(nonatomic,assign) float price;
@property(nonatomic,strong) NSString * url;

@end

@protocol GoodsDetailShopItem
@end

@interface GoodsDetailData : JSONModel

@property(nonatomic,strong) NSString * abstracts;
@property(nonatomic,strong) NSString * author;
@property(nonatomic,strong) NSString * authorIcon;
@property(nonatomic,strong) NSString * coverPhoto;
@property(nonatomic,assign) int favNum;
@property(nonatomic,assign) BOOL favStatus;
@property(nonatomic,assign) int goodsId;
@property(nonatomic,strong) NSArray<GoodsDetailImgItem> * imgs;
@property(nonatomic,assign) float price;
@property(nonatomic,strong) NSArray<GoodsDetailShopItem> * shopList;
@property(nonatomic,strong) NSString * title;
@property(nonatomic,assign) int upNum;
@property(nonatomic,assign) BOOL upStatus;

@end

@interface GoodsDetailModel : BaseModel

@property(nonatomic,strong) GoodsDetailData * data;

@end
