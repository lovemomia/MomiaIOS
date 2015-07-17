//
//  StringUtils.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/13.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringUtils : NSObject

+ (NSString *)stringForPrice:(CGFloat)price;

+ (NSString *)stringForWeekday:(NSInteger)weekday;

+ (NSString *)stringForMonth:(int) month;

@end
