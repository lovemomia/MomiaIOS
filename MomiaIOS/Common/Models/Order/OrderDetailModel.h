//
//  OrderDetailModel.h
//  MomiaIOS
//
//  Created by Owen on 15/7/9.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"

@interface OrderDetailDataModel : JSONModel

@property(nonatomic,assign) NSInteger productId;
@property(nonatomic,strong) NSString * cover;
@property(nonatomic,strong) NSString * title;
@property(nonatomic,strong) NSString * scheduler;
@property(nonatomic,strong) NSString * address;
@property(nonatomic,assign) CGFloat price;

@property(nonatomic,assign) NSInteger orderNo;
@property(nonatomic,strong) NSString * addTime;
@property(nonatomic,strong) NSString * participants;
@property(nonatomic,assign) CGFloat totalFee;

@property(nonatomic,strong) NSString * contacts;
@property(nonatomic,strong) NSString * mobile;

@end

@interface OrderDetailModel : BaseModel

@property(nonatomic,strong) OrderDetailDataModel * data;

@end
