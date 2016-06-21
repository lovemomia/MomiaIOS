//
//  AlertNotice.m
//  MomiaIOS
//
//  Created by Owen on 15/5/20.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "AlertNotice.h"

@implementation AlertNotice
+(void) showNotice : (NSString *) noticeInfo
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"通知"
                          message:noticeInfo
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    
    
}

@end
