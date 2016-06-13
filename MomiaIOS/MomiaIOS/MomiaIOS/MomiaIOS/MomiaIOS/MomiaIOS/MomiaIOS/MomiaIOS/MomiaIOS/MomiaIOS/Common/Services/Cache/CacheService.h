//
//  CacheService.h
//  MomiaIOS
//
//  缓存服务，提供数据缓存支持
//
//  Created by Deng Jun on 15/7/21.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISDiskCache.h"

@interface CacheService : NSObject

/**
 *  获取cache服务单例
 */
+ (instancetype)defaultService;

- (BOOL)hasObjectForKey:(id<NSCoding>)key;

- (id)objectForKey:(id <NSCoding>)key;

- (long)timeForKey:(id <NSCoding>)key;

- (void)setObject:(id <NSCoding>)object forKey:(id <NSCoding>)key;

- (void)removeObjectForKey:(id)key;

@end
