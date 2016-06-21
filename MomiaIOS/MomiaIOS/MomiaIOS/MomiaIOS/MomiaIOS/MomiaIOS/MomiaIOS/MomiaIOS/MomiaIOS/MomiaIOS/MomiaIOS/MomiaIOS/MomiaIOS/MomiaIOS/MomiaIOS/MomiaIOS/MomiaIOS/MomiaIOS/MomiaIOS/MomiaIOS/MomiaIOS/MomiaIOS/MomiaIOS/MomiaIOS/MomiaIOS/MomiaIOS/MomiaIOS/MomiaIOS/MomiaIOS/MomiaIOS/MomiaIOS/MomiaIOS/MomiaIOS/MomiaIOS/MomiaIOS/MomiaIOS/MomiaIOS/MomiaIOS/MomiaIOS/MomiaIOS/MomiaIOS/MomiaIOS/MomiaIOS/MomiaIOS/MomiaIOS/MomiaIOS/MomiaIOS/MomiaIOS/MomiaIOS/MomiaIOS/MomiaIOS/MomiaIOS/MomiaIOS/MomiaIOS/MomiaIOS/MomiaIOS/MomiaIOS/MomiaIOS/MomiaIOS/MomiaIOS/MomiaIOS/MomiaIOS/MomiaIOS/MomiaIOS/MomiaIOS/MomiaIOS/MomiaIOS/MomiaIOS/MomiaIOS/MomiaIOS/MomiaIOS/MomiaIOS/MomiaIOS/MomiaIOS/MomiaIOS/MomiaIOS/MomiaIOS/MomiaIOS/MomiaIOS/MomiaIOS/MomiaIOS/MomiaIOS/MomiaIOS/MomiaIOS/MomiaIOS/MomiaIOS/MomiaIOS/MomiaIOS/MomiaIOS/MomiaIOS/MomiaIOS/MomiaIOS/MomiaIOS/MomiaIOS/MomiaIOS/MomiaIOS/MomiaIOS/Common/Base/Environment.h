//
//  Environment.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/20.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Environment : NSObject

+ (instancetype)singleton;

@property (strong, nonatomic) NSString *networkType;

@end
