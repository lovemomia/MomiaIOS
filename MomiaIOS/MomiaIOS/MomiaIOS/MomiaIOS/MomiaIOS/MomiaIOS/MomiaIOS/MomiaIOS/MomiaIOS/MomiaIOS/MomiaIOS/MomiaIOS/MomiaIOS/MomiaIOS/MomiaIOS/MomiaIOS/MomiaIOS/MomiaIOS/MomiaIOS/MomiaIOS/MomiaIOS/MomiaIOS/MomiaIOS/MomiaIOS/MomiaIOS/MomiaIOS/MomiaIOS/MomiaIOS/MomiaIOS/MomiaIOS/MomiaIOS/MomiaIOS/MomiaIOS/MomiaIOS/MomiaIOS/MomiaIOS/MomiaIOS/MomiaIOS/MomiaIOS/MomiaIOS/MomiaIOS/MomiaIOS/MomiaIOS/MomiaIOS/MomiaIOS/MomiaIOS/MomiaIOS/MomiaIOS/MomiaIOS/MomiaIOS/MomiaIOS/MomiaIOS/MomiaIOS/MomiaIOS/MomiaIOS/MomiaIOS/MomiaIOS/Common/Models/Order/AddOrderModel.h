//
//  AddOrderModel.h
//  MomiaIOS
//
//  Created by Owen on 15/6/30.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "JSONModel.h"

@interface AddOrderPriceModel : JSONModel

@property(nonatomic,strong) NSNumber<Optional> * adult;
@property(nonatomic,assign) CGFloat price;
@property(nonatomic,strong) NSNumber<Optional> * child;
@property(nonatomic,assign) NSInteger count;

@end

@protocol AddOrderPriceModel <NSObject>


@end


@interface AddOrderModel : JSONModel

@property(nonatomic,assign) NSInteger productId;
@property(nonatomic,assign) NSInteger skuId;
@property(nonatomic,strong) NSString * contacts;
@property(nonatomic,strong) NSString * mobile;
@property(nonatomic,strong) NSArray * participants;
@property(nonatomic,strong) NSArray<AddOrderPriceModel> * prices;

@end
