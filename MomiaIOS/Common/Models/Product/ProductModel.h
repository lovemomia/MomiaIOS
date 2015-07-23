//
//  ProductItemModel.h
//  MomiaIOS
//
//  Created by Owen on 15/6/17.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "JSONModel.h"

@interface ProductBodyModel : JSONModel

@property(nonatomic,strong) NSString<Optional> * text;
@property(nonatomic,strong) NSString<Optional> * label;
@property(nonatomic,strong) NSString<Optional> * img;
@property(nonatomic,strong) NSString<Optional> * link;

@end

@protocol ProductBodyModel

@end

@interface ProductContentModel : JSONModel

@property (nonatomic,strong) NSArray<ProductBodyModel> * body;
@property (nonatomic,strong) NSString * style;
@property (nonatomic,strong) NSString * title;

@end

@protocol ProductContentModel

@end


@interface ProductCustomersModel : JSONModel

@property(nonatomic,strong) NSArray<Optional> * avatars;
@property(nonatomic,strong) NSString * text;

@end


@interface ProductModel : JSONModel

@property (nonatomic, strong) NSString * cover;
@property (nonatomic, strong) NSString * scheduler;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) NSInteger pID;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) NSInteger joined;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * poi;
@property (nonatomic, strong) NSArray<ProductContentModel,Optional> * content;
@property (nonatomic, strong) NSString<Optional> * crowd;
@property (nonatomic, strong) ProductCustomersModel<Optional> * customers;
@property (nonatomic, strong) NSArray<Optional> * imgs;

@property (nonatomic, strong) NSString<Optional> * url; // 分享url
@property (nonatomic, strong) NSString<Optional> * abstracts; // 分享简介

@property (nonatomic, assign) BOOL soldOut;
@property (nonatomic, assign) BOOL favored; //是否收藏
@property (nonatomic, assign) BOOL opened; //是否报名开放中

@property (nonatomic, strong) NSString<Optional> * thumb; // 分享小图标
@property (nonatomic, strong) NSArray<Optional> * tags;


@end
