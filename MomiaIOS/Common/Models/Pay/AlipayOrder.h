//
//  AlipayOrder.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/9.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlipayOrder : JSONModel

@property(nonatomic, strong) NSString * partner;
@property(nonatomic, strong) NSString * seller_id;
@property(nonatomic, strong) NSString * out_trade_no;
@property(nonatomic, strong) NSString * subject;
@property(nonatomic, strong) NSString * body;
@property(nonatomic, strong) NSString * total_fee;
@property(nonatomic, strong) NSString * notify_url;

@property(nonatomic, strong) NSString * service;
@property(nonatomic, strong) NSString * payment_type;
@property(nonatomic, strong) NSString * input_charset;
@property(nonatomic, strong) NSString * it_b_pay;
@property(nonatomic, strong) NSString * show_url;

@property(nonatomic, strong) NSString * sign;
@property(nonatomic, strong) NSString * sign_type;
@property(nonatomic, strong) NSString<Optional> * appID;

@property(nonatomic, assign) BOOL successful;

@property(nonatomic, readonly) NSMutableDictionary<Optional> * extraParams;



@end
