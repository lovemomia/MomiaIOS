//
//  FillOrderModel.h
//  MomiaIOS
//
//  Created by Owen on 15/6/26.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"

@interface FillOrderPriceModel : JSONModel

@property(nonatomic,assign) NSInteger adult;
@property(nonatomic,assign) NSInteger child;
@property(nonatomic,assign) CGFloat price;
@property(nonatomic,strong) NSString * unit;

@end

@protocol FillOrderPriceModel <NSObject>

@end

@interface FillOrderSkuModel : JSONModel

@property(nonatomic,assign) CGFloat minPrice;
@property(nonatomic,strong) NSArray<FillOrderPriceModel> * prices;
@property(nonatomic,assign) NSInteger productId;
@property(nonatomic,assign) NSInteger skuId;
@property(nonatomic,assign) NSInteger stock;
@property(nonatomic,strong) NSString * time;

@end

@protocol FillOrderSkuModel <NSObject>


@end

@interface FillOrderContactsModel : JSONModel

@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, strong) NSString * name;

@end

@interface FillOrderDataModel : JSONModel

@property(nonatomic,strong) FillOrderContactsModel * contacts;
@property(nonatomic,strong) NSArray<FillOrderSkuModel> * skus;

@end

@interface FillOrderModel : BaseModel

@property(nonatomic,strong) FillOrderDataModel * data;

@end
