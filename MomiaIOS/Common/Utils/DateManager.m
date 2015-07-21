//
//  DateUtils.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/17.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "DateManager.h"

@interface DateManager()
@property (nonatomic, assign) long timeDifference;
@end

@implementation DateManager

+ (instancetype)shareManager {
    static DateManager *__manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[self alloc] init];
    });
    return __manager;
}

- (void)setServerTimeSeconds:(long)time {
    self.timeDifference = time - (long)[[NSDate date]timeIntervalSince1970];
}

- (long)serverTimeSeconds {
    return (long)[[NSDate date]timeIntervalSince1970] + self.timeDifference;
}

- (int)serverTimeMonth {
    NSDate *now = [NSDate dateWithTimeIntervalSince1970:self.serverTimeSeconds];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    int month = (int)[dateComponent month];
    return month;
}

@end
