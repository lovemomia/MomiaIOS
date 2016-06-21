//
//  LeaderSkuModel.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/8/4.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"
#import "ProductModel.h"

@interface LeaderSku : JSONModel
@property(nonatomic,assign) CGFloat minPrice;
@property(nonatomic,assign) NSInteger productId;
@property(nonatomic,assign) NSInteger skuId;
@property(nonatomic,assign) NSInteger stock;
@property(nonatomic,strong) NSString * time;
@property(nonatomic,assign) NSInteger limit;// 购买限额，0表示不限
@property(nonatomic,assign) BOOL hasLeader;// 是否已有领队
@property(nonatomic,strong) NSString *leaderInfo;// 领队信息
@property(nonatomic,strong) NSString<Optional> * desc;
@property(nonatomic,assign) NSInteger type;
@end

@protocol LeaderSku <NSObject>
@end

@interface LeaderSkuData : JSONModel
@property (nonatomic, strong) ProductModel *product;
@property (nonatomic, strong) NSArray<LeaderSku> *skus;
@end

@interface LeaderSkuModel : BaseModel
@property (nonatomic, strong) LeaderSkuData *data;
@end
