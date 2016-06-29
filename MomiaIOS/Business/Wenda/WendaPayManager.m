//
//  WendaPayManager.m
//  MomiaIOS
//
//  Created by Deng Jun on 16/6/24.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "WendaPayManager.h"
#import "CustomIOSAlertView.h"
#import "WechatPayModel.h"
#import "WechatPayDelegate.h"
#import "AlipayOrderModel.h"
#import "PayTool.h"
#import "AppDelegate.h"

@interface WendaPayManager()

@property (nonatomic, strong) NSDictionary *order;
@property (nonatomic, assign) id<WechatPayDelegate> delegate;

@end

@implementation WendaPayManager

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(pay:(NSDictionary *)order callback:(RCTResponseSenderBlock)callback)
{
    [self showPayAlert:order];
}

- (void)showPayAlert:(NSDictionary *)order {
    
    self.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.order = order;
    
    NSLog(@"----%@",self.order);
    dispatch_async(dispatch_get_main_queue(), ^(void){
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"WendaPayAlertView" owner:self options:nil];
        
        if([[NSString stringWithFormat:@"%@", [order objectForKey:@"use"]] isEqualToString:@"0"]) {
            
            UIView *containerView = array[1];
            
            [alertView setContainerView:containerView];
            
            UIButton *weiXinView = [containerView viewWithTag:1000];
            [weiXinView addTarget:self action:@selector(tapweixin) forControlEvents:UIControlEventTouchUpInside];
            
            
            UIButton *zhifubaoButton = [containerView viewWithTag:1001];
            [zhifubaoButton addTarget:self action:@selector(tapZhifubao) forControlEvents:UIControlEventTouchUpInside];
            
            
            
        } else {
            
            UIView *containerView = array[0];
            
            UIButton *remainView = [containerView viewWithTag:1000];
            [remainView addTarget:self action:@selector(remainPay) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *weiXinView = [containerView viewWithTag:1001];
            [weiXinView addTarget:self action:@selector(tapweixin) forControlEvents:UIControlEventTouchUpInside];
            
            
            UIButton *zhifubaoButton = [containerView viewWithTag:1002];
            [zhifubaoButton addTarget:self action:@selector(tapZhifubao) forControlEvents:UIControlEventTouchUpInside];
            
            [alertView setContainerView:array[0]];
            
            
        }
        
        [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
            
            NSLog(@"-----%d",buttonIndex);
        }];
        
        
        [alertView setButtonTitles:@[@"取消"]];
        [alertView setUseMotionEffects:TRUE];
        [alertView show];
    });
}

//微信支付
- (void)tapweixin{
    
    NSLog(@"----tap wei xin %@",self.order);
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:@{@"type":@"APP",
                                                                                    @"oid":[self.order objectForKey:@"id"]}];
    
    NSLog(@"----%@",params);
    
    [[HttpService defaultService]POST:URL_HTTPS_APPEND_PATH(@"/v1/prepay/wd_weixin")
                           parameters:params JSONModelClass:[WechatPayModel class]
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  
                                  //前往支付
                                  if ([responseObject isKindOfClass:[WechatPayModel class]]) {
                                      [self.delegate sendPay:((WechatPayModel *)responseObject).data];
                                      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPayResp:) name:@"payResp" object:nil];
                                  }
                              }
     
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  //支付失败，不管
                              }];
}

//支付宝支付
- (void)tapZhifubao {
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:@{@"type":@"APP",
                                                                                    @"oid":[self.order objectForKey:@"id"]}];
    [[HttpService defaultService]POST:URL_HTTPS_APPEND_PATH(@"/v1/prepay/wd_alipay")
                           parameters:params JSONModelClass:[AlipayOrderModel class]
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  
                                  //前往支付
                                  if ([responseObject isKindOfClass:[AlipayOrderModel class]]) {
                                      PayTool *payTool = [PayTool new];
                                      [payTool startAlipay:((AlipayOrderModel *)responseObject).data payResult:^(BOOL success){
                                          //支付成功回调
                                          
                                      }] ;
                                  }
                              }
     
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  
                                  NSLog(@"------fail");
                              }];
}

//余额支付
- (void)remainPay {
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:@{@"type":@"APP",
                                                                                    @"oid":[self.order objectForKey:@"id"]}];
    [[HttpService defaultService]POST:URL_HTTPS_APPEND_PATH(@"/v1/prepay/wd_asset")
                           parameters:params JSONModelClass:[AlipayOrderModel class]
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  
                                  //前往支付
                                  if ([responseObject isKindOfClass:[AlipayOrderModel class]]) {
                                      PayTool *payTool = [PayTool new];
                                      [payTool startAlipay:((AlipayOrderModel *)responseObject).data payResult:^(BOOL success){
                                          //支付成功回调
                                          
                                      }] ;
                                  }
                              }
     
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  
                                  NSLog(@"------fail");
                              }];
}

-(void)onPayResp:(NSNotification*)notify {
    
}


@end
