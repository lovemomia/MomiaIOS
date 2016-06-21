//
//  AlipayOrder.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/9.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "AlipayOrder.h"

@implementation AlipayOrder

- (NSString *)description {
    NSMutableString * discription = [NSMutableString string];
    if (self.partner) {
        [discription appendFormat:@"partner=\"%@\"", self.partner];
    }
    
    if (self.out_trade_no) {
        [discription appendFormat:@"&seller_id=\"%@\"", self.seller_id];
    }
    if (self.out_trade_no) {
        [discription appendFormat:@"&out_trade_no=\"%@\"", self.out_trade_no];
    }
    if (self.subject) {
        [discription appendFormat:@"&subject=\"%@\"", self.subject];
    }
    
    if (self.body) {
        [discription appendFormat:@"&body=\"%@\"", self.body];
    }
    if (self.total_fee) {
        [discription appendFormat:@"&total_fee=\"%@\"", self.total_fee];
    }
    if (self.notify_url) {
        [discription appendFormat:@"&notify_url=\"%@\"", self.notify_url];
    }
    
    if (self.service) {
        [discription appendFormat:@"&service=\"%@\"",self.service];//mobile.securitypay.pay
    }
    if (self.payment_type) {
        [discription appendFormat:@"&payment_type=\"%@\"",self.payment_type];//1
    }
    
    if (self.input_charset) {
        [discription appendFormat:@"&_input_charset=\"%@\"",self.input_charset];//utf-8
    }
    if (self.it_b_pay) {
        [discription appendFormat:@"&it_b_pay=\"%@\"",self.it_b_pay];//30m
    }
    if (self.show_url) {
        [discription appendFormat:@"&show_url=\"%@\"",self.show_url];//m.alipay.com
    }
//    if (self.rsaDate) {
//        [discription appendFormat:@"&sign_date=\"%@\"",self.si];
//    }
//    if (self.appID) {
//        [discription appendFormat:@"&app_id=\"%@\"",self.appID];
//    }
    if (self.sign) {
        [discription appendFormat:@"&sign=\"%@\"",self.sign];
    }
    if (self.sign_type) {
        [discription appendFormat:@"&sign_type=\"%@\"",self.sign_type];
    }
    for (NSString * key in [self.extraParams allKeys]) {
        [discription appendFormat:@"&%@=\"%@\"", key, [self.extraParams objectForKey:key]];
    }
    return discription;
}

@end
