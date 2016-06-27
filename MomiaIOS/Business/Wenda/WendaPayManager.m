//
//  WendaPayManager.m
//  MomiaIOS
//
//  Created by Deng Jun on 16/6/24.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "WendaPayManager.h"
#import "CustomIOSAlertView.h"

@implementation WendaPayManager

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(pay:(NSDictionary *)order callback:(RCTResponseSenderBlock)callback)
{
    [self showPayAlert:order];
}

- (void)showPayAlert:(NSDictionary *)order {

    dispatch_async(dispatch_get_main_queue(), ^(void){
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 100)];
//        [view setBackgroundColor:[UIColor redColor]];
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"WendaPayAlertView" owner:self options:nil];
        
        if([[NSString stringWithFormat:@"%@", [order objectForKey:@"use"]] isEqualToString:@"0"]) {
            [alertView setContainerView:array[1]];
        } else {
            [alertView setContainerView:array[0]];
        }
        
        [alertView setButtonTitles:@[@"取消"]];
        [alertView setUseMotionEffects:TRUE];
        [alertView show];
    });
}

@end
