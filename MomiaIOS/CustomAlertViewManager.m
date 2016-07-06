//
//  CustomAlertViewManager.m
//  MomiaIOS
//
//  Created by mosl on 16/7/6.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "CustomAlertViewManager.h"
#import "CustomIOSAlertView.h"

@interface CustomAlertViewManager()

@property (nonatomic, strong) CustomIOSAlertView *alertView;

@end

@implementation CustomAlertViewManager

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(show:(NSString *)msg callback:(RCTResponseSenderBlock)callback)
{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        
        if (self.alertView != nil) {
            [self.alertView close];
        }
        
        self.alertView = [[CustomIOSAlertView alloc] init];
        
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"WendaPayAlertView" owner:self options:nil];
        UIView *containerView = array[2];
        
        [self.alertView setContainerView:containerView];
        
        UILabel *label = [containerView viewWithTag:1000];
        label.text = msg;
        
        [self.alertView setButtonTitles:@[@"好的"]];
        [self.alertView setUseMotionEffects:TRUE];
        [self.alertView show];
        
    });
    
    callback(@[]);
}

@end
