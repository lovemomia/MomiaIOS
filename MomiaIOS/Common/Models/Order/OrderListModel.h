//
//  OrderListModel.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/5.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"
#import "Order.h"

@protocol Order
@end

@interface OrderListData : JSONModel
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, strong) NSNumber<Optional> *nextIndex;
@property (nonatomic, strong) NSArray<Order> *list;
@end

@interface OrderListModel : BaseModel

@property (nonatomic, strong) OrderListData *data;

@end
