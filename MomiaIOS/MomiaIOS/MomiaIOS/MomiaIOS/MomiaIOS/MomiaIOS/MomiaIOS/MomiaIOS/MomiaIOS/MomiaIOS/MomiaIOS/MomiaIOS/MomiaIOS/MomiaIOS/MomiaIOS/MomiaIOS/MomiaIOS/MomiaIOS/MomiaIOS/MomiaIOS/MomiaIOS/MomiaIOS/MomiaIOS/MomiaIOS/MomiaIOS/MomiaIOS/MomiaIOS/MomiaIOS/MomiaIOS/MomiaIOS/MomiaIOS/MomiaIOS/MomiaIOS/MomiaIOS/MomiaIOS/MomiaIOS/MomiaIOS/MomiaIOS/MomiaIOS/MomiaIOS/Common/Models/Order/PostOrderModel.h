//
//  PostOrderModel.h
//  MomiaIOS
//
//  Created by Owen on 15/6/30.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"

@interface PostOrderData : JSONModel

@property(nonatomic,assign) NSInteger count;
@property(nonatomic,assign) NSInteger orderId;
//@property(nonatomic,strong) NSString * participants;
//@property(nonatomic,assign) NSInteger productId;
//@property(nonatomic,assign) NSInteger skuId;
@property(nonatomic,assign) CGFloat totalFee;

@end

@interface PostOrderModel : BaseModel

@property(nonatomic,strong) PostOrderData * data;

@end
