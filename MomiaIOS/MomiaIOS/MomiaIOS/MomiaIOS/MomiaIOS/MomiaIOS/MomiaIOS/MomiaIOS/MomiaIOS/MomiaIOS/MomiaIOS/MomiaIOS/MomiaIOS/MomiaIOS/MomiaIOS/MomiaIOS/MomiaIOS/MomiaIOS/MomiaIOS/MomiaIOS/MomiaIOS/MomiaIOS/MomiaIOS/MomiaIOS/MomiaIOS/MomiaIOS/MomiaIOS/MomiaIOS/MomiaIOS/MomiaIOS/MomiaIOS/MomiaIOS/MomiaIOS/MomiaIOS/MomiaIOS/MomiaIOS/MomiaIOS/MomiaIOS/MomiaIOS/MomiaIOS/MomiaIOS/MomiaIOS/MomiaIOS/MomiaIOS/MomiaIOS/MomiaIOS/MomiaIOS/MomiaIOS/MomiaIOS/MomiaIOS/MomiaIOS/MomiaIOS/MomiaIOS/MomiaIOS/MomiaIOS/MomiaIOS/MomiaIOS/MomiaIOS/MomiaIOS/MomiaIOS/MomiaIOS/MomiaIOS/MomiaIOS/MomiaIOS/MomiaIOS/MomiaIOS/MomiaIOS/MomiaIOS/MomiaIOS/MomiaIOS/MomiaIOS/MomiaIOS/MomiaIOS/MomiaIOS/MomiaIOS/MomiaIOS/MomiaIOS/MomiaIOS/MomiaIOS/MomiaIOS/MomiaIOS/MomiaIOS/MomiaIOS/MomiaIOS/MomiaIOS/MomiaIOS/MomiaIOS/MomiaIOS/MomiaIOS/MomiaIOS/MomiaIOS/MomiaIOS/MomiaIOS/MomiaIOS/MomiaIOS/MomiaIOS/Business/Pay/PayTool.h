//
//  PayTool.h
//  MomiaIOS
//
//  支付工具（对第三方支付的封装）
//
//  Created by Deng Jun on 15/7/9.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AlipaySDK/AlipaySDK.h>
#import "AlipayOrder.h"

typedef void (^BlockPayResult)(BOOL success);

@interface PayTool : NSObject

- (void)startAlipay:(AlipayOrder *)order payResult:(BlockPayResult)callback;

@end
