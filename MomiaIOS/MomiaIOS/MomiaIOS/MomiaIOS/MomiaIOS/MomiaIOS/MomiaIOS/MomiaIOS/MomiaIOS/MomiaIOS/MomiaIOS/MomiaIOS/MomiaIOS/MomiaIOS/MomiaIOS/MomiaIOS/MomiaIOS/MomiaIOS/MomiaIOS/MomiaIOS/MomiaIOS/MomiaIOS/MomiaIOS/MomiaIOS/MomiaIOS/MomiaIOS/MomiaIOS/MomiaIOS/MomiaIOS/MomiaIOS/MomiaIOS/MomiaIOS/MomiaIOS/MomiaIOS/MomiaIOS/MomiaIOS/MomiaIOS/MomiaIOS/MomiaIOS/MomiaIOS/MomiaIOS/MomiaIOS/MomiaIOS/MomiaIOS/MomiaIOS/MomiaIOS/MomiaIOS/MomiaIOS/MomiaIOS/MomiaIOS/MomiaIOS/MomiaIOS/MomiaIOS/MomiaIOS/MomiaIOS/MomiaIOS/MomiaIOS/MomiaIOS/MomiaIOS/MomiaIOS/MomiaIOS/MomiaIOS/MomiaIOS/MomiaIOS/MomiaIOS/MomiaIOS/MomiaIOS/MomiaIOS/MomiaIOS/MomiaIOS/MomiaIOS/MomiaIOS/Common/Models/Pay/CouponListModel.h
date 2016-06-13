//
//  CouponListModel.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/14.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"

@protocol Coupon <NSObject>

@end

@interface CouponListData : JSONModel
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, strong) NSArray<Coupon>  *list;
@end

@interface CouponListModel : BaseModel

@property (nonatomic, strong) CouponListData *data;

@end
