//
//  FavouriteModel.h
//  MomiaIOS
//
//  Created by Owen on 15/5/29.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"

@protocol ProductModel
@end

@interface FavouriteData : JSONModel

@property(nonatomic,strong) NSArray<ProductModel> * list;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, strong) NSNumber<Optional> *nextIndex;

@end

@interface FavouriteModel : BaseModel

@property(nonatomic,strong) FavouriteData * data;

@end
