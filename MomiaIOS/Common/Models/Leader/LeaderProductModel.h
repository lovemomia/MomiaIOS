//
//  LeaderProductModel.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/8/3.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"

@protocol ProductModel
@end

@interface LeaderProductData : JSONModel
@property (nonatomic, strong) NSArray<ProductModel> * list;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, strong) NSNumber<Optional> *nextIndex;
@end

@interface LeaderProductModel : BaseModel
@property(nonatomic,strong) LeaderProductData * data;
@end
