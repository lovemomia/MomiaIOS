//
//  HomeModel.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/8.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"
#import "ProductModel.h"

@interface HomeBannerModel : JSONModel

@property(nonatomic,strong) NSString * cover;
@property(nonatomic,strong) NSString * action;

@end

@protocol HomeBannerModel

@end

@protocol ProductModel

@end

@interface HomeDataModel : JSONModel

@property(nonatomic,strong) NSArray<HomeBannerModel,Optional> * banners;
//@property(nonatomic,assign) NSInteger<Optional> nextpage;
@property(nonatomic,strong) NSArray<ProductModel> * products;

@end

@interface HomeModel : BaseModel

@property (strong, nonatomic) HomeDataModel *data;

@end
