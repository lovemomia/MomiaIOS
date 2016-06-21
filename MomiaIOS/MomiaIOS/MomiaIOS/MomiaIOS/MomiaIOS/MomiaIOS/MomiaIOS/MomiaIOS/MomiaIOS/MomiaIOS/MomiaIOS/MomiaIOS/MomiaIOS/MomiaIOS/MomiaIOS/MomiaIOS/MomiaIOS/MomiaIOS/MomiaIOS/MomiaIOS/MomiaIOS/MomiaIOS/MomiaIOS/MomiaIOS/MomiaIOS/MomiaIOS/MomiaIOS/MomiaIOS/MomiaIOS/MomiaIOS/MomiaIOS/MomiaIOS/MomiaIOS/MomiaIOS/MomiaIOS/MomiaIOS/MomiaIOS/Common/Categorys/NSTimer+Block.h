//
//  NSTimer+Block.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/1.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Blocks)

+ (id)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;
+ (id)timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;

@end
