//
//  AlipayOrder.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/9.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlipayOrder : NSObject

@property(nonatomic, copy) NSString * partner;
@property(nonatomic, copy) NSString * seller_id;
@property(nonatomic, copy) NSString * out_trade_no;
@property(nonatomic, copy) NSString * subject;
@property(nonatomic, copy) NSString * body;
@property(nonatomic, copy) NSString * total_fee;
@property(nonatomic, copy) NSString * notify_url;

@property(nonatomic, copy) NSString * service;
@property(nonatomic, copy) NSString * payment_type;
@property(nonatomic, copy) NSString * input_charset;
@property(nonatomic, copy) NSString * it_b_pay;
@property(nonatomic, copy) NSString * showUrl;

@property(nonatomic, copy) NSString * sign;
@property(nonatomic, copy) NSString * sign_type;
@property(nonatomic, copy) NSString * appID;

@property(nonatomic, assign) BOOL successful;

@property(nonatomic, readonly) NSMutableDictionary * extraParams;



@end
