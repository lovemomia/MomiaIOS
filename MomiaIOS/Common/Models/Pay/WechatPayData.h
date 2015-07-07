//
//  WechatPay.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/7.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "JSONModel.h"

@interface WechatPayData : JSONModel

@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) NSString<Optional> *partnerId;
@property (nonatomic, strong) NSString *timeStamp;
@property (nonatomic, strong) NSString *nonceStr;
@property (nonatomic, strong) NSString *prepayId;
@property (nonatomic, strong) NSString *signType;
@property (nonatomic, strong) NSString *paySign;
@property (nonatomic, assign) BOOL successful;



@end
