//
//  PayTool.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/9.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "PayTool.h"
#import "AlipayOrder.h"

@implementation PayTool

- (void)startAlipay {
//    AlipayOrder *order = [[AlipayOrder alloc] init];
//    order.partner = @"2088911944697039";
//    order.seller = seller;
//    order.tradeNO = [self generateTradeNO]; //订单ID(由商家□自□行制定)
//    order.productName = product.subject; //商品标题
//    order.productDescription = product.body; //商品描述
//    order.amount = [NSString stringWithFormat:@"%.2f",product.price]; //商品价格
//    
//    order.notifyURL = @"http://www.xxx.com"; //回调URL
//    order.service = @"mobile.securitypay.pay";
//    order.paymentType = @"1";
//    order.inputCharset = @"utf-8";
//    order.itBPay = @"30m";
//    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
//    NSString *appScheme = @"duola";
//    //将商品信息拼接成字符串
//    NSString *orderSpec = [order description]; NSLog(@"orderSpec = %@",orderSpec);
//    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循 RSA 签名规范, 并将签名字符串 base64 编码和 UrlEncode
//    id<DataSigner> signer = CreateRSADataSigner(privateKey);
//    NSString *signedString = [signer signString:orderSpec];
//    //将签名成功字符串格式化为订单字符串,请严格按照该格式
//    NSString *orderString = nil;
//    if (signedString != nil) {
//        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                       orderSpec, signedString, @"RSA"];
//        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//            NSLog(@"reslut = %@",resultDic);
//            
//            
//        }];
//    }
}

@end
