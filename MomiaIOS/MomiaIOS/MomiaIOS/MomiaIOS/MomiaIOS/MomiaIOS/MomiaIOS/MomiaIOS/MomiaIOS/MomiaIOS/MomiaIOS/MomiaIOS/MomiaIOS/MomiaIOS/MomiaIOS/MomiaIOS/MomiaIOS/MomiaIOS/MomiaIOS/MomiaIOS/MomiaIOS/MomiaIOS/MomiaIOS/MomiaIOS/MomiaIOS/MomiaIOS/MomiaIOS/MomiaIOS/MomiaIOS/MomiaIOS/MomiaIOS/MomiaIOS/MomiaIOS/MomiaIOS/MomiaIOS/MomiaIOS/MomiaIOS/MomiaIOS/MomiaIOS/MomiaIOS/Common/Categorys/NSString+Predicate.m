//
//  NSString+Predicate.m
//  MomiaIOS
//
//  Created by Owen on 15/7/1.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "NSString+Predicate.h"

@implementation NSString (Predicate)

-(BOOL)isMobileNumber
{
    NSString * mobile = @"^1[3|4|5|7|8][0-9]\\d{8}$";
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobile];
    
    if([predicate evaluateWithObject:self] == YES) {
        return YES;
    }
    
    return NO;
}


@end
