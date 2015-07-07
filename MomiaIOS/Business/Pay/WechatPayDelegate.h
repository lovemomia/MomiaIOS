//
//  WechatPayDelegate.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/6/12.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WechatPayData.h"
#import "PostOrderModel.h"

@protocol WechatPayDelegate <NSObject>

- (void) sendPay:(WechatPayData *)data;
- (void) sendPay_demo;

@end
