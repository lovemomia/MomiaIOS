//
//  WechatPay.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/7.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "JSONModel.h"

@interface WechatPayData : JSONModel

@property (nonatomic, strong) NSString *appid;
@property (nonatomic, strong) NSString *partnerid;
@property (nonatomic, strong) NSString *package_app;
@property (nonatomic, strong) NSString *timestamp;
@property (nonatomic, strong) NSString *noncestr;
@property (nonatomic, strong) NSString *prepayid;
//@property (nonatomic, strong) NSString *signType;
@property (nonatomic, strong) NSString *sign;
@property (nonatomic, assign) BOOL successful;



@end
