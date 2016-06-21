//
//  OrderDetailModel.h
//  MomiaIOS
//
//  Created by Owen on 15/7/9.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"
#import "Order.h"

@interface OrderDetailModel : BaseModel

@property(nonatomic,strong) Order *data;

@end
