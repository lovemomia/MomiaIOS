//
//  OrderPersonModel.h
//  MomiaIOS
//
//  Created by Owen on 15/6/29.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"
#import "OrderPerson.h"


@protocol OrderPerson <NSObject>
@end

@interface OrderPersonModel : BaseModel

@property(nonatomic,strong) NSArray<OrderPerson> * data;

@end
