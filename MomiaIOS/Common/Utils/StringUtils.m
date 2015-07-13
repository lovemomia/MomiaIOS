//
//  StringUtils.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/13.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "StringUtils.h"

@implementation StringUtils

+ (NSString *)stringForPrice:(CGFloat)price {
    NSString *priceStr = [NSString stringWithFormat:@"%f", price];
    NSRange change = [priceStr rangeOfString:@".00"];
    if(change.length > 0) {
        return [NSString stringWithFormat:@"%d", (int)price];
    }
    return [NSString stringWithFormat:@"%.2f", price];
}

@end
