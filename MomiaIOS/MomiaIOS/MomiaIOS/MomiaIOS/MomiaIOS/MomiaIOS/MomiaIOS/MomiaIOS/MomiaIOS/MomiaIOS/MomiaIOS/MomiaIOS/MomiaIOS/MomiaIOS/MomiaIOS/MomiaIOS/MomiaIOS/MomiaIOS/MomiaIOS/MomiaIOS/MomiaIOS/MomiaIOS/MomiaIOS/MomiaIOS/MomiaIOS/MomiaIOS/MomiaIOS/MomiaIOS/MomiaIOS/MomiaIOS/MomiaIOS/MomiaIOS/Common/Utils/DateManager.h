//
//  DateUtils.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/17.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateManager : NSObject

+ (instancetype)shareManager;

@property (nonatomic, assign) long serverTimeSeconds;

@property (nonatomic, assign) int serverTimeMonth;

@end
