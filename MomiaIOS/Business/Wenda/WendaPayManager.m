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

@property (nonatomic, strong) CustomIOSAlertView *alertView;

@end

@implementation WendaPayManager

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(pay:(NSDictionary *)order callback:(RCTResponseSenderBlock)callback)
{
    [self showPayAlert:order];
}

RCT_EXPORT_METHOD(dismissPayAlert:(NSString *)alertMsg callback:(RCTResponseSenderBlock)callback){
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        
        if (self.alertView != nil) {
            [self.alertView close];
        }
        
        self.alertView = [[CustomIOSAlertView alloc] init];
        
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"WendaPayAlertView" owner:self options:nil];
        UIView *containerView = array[2];
        
        [self.alertView setContainerView:containerView];
        
        UILabel *label = [containerView viewWithTag:1000];
        label.text = alertMsg;
        
        [self.alertView setButtonTitles:@[@"好的"]];
        [self.alertView setUseMotionEffects:TRUE];
        [self.alertView show];
        
    });
}

- (void)showPayAlert:(NSDictionary *)order{
    
    self.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.order = order;
    
    NSLog(@"----%@",self.order);
    dispatch_async(dispatch_get_main_queue(), ^(void){
        self.alertView = [[CustomIOSAlertView alloc] init];
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"WendaPayAlertView" owner:self options:nil];
        
        if([[NSString stringWithFormat:@"%@", [order objectForKey:@"use"]] isEqualToString:@"0"]) {
            
            UIView *containerView = array[1];
            
            [self.alertView setContainerView:containerView];
            
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
            
            [self.alertView setContainerView:array[0]];
            
            
        }
        
        [self.alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
            
            NSLog(@"-----%d",buttonIndex);
        }];
        
        
        [self.alertView setButtonTitles:@[@"取消"]];
        [self.alertView setUseMotionEffects:TRUE];
        [self.alertView show];
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
                                          //发送广播，支付成功
                                          [[NSNotificationCenter defaultCenter]postNotificationName:@"paySuccess" object:nil userInfo:@{@"oid":[self.order objectForKey:@"id"]}];
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
