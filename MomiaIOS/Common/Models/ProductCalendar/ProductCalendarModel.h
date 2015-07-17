//
//  ProductCalendarModel.h
//  MomiaIOS
//
//  Created by Owen on 15/7/17.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"
#import "ProductModel.h"



@protocol ProductModel <NSObject>

@end


@interface ProductCalendarMonthDataModel : JSONModel

@property(nonatomic,strong) NSString * date;
@property(nonatomic,strong) NSArray<ProductModel> * products;

@end

@protocol ProductCalendarMonthDataModel <NSObject>

@end

@interface ProductCalendarMonthModel : BaseModel

@property(nonatomic,strong) NSArray<ProductCalendarMonthDataModel> * data;

@end

@interface ProductCalendarDataModel : JSONModel

@property(nonatomic,strong) NSArray<ProductModel> * list;
@property(nonatomic,strong) NSNumber<Optional> * nextIndex;
@property(nonatomic,assign) NSInteger totalCount;

@end

@interface ProductCalendarModel : BaseModel

@property(nonatomic,strong) ProductCalendarDataModel * data;

@end
