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
    
    NSString *cutStr = [NSString stringWithFormat:@"%.2f", price];
    NSRange end = [cutStr rangeOfString:@".[0-9][1-9]" options:NSRegularExpressionSearch];
    if (end.length > 0) {
        return cutStr;
    }
    return [NSString stringWithFormat:@"%.1f", price];
}

+ (NSString *)stringForWeekday:(NSInteger)weekday
{
    NSString * str;
    switch (weekday) {
        case 1:
            str = @"日";
            break;
        case 2:
            str = @"一";
            break;
        case 3:
            str = @"二";
            break;
        case 4:
            str = @"三";
            break;
        case 5:
            str = @"四";
            break;
        case 6:
            str = @"五";
            break;
        case 7:
            str = @"六";
            break;
        default:
            str = @"?";
            break;
    }
    return str;
}

+ (NSString *)stringForMonth:(int) month
{
    NSString * str;
    switch (month) {
        case 1:
            str = @"一";
            break;
        case 2:
            str = @"二";
            break;
        case 3:
            str = @"三";
            break;
        case 4:
            str = @"四";
            break;
        case 5:
            str = @"五";
            break;
        case 6:
            str = @"六";
            break;
        case 7:
            str = @"七";
            break;
        case 8:
            str = @"八";
            break;
        case 9:
            str = @"九";
            break;
        case 10:
            str = @"十";
            break;
        case 11:
            str = @"十一";
            break;
        case 12:
            str = @"十二";
            break;
        default:
            str = @"";
            break;
    }
    return str;

}



@end
