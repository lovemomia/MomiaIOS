//
//  SkuListModel.h
//  MomiaIOS
//
//  提交订单页sku列表
//
//  Created by Deng Jun on 15/10/15.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"

@interface Sku : JSONModel
@property (nonatomic, strong) NSNumber *ids;
@property (nonatomic, strong) NSNumber *subjectId;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSNumber<Optional> *count;
@property (nonatomic, strong) NSNumber<Optional> *limit;
@end

@interface Contact : JSONModel
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *name;
@end

@protocol Sku <NSObject>
@end

@interface SkuListData : JSONModel
@property (nonatomic, strong) NSArray<Sku> *skus;
@property (nonatomic, strong) Contact *contact;
@end

@interface SkuListModel : BaseModel
@property (nonatomic, strong) SkuListData *data;
@end
