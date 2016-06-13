//
//  Toast.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/9/22.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "Toast.h"

@implementation Toast

+ (void)make:(UIView *)view andShow:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

@end
