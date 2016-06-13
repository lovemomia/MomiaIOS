//
//  CacheService.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/21.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "CacheService.h"

@implementation CacheService

+ (instancetype)defaultService {
    static CacheService *__service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __service = [[self alloc] init];
    });
    return __service;
}

- (instancetype)init {
    if (self = [super init]) {
        [ISDiskCache sharedCache].limitOfSize = 10 * 1024 * 1024; // 10MB
    }
    return self;
}

- (BOOL)hasObjectForKey:(id<NSCoding>)key {
    return [[ISDiskCache sharedCache] hasObjectForKey:key];
}

- (id)objectForKey:(id <NSCoding>)key {
    return [[ISDiskCache sharedCache] objectForKey:key];
}

- (long)timeForKey:(id <NSCoding>)key {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [[ISDiskCache sharedCache] filePathForKey:key];
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:path error:nil];
    if (fileAttributes) {
        NSDate *date = [fileAttributes objectForKey:NSFileCreationDate];
        return [date timeIntervalSince1970];
    }
    return -1;
}

- (void)setObject:(id <NSCoding>)object forKey:(id <NSCoding>)key {
    [[ISDiskCache sharedCache] setObject:object forKey:key];
}

- (void)removeObjectForKey:(id)key {
    [[ISDiskCache sharedCache] removeObjectForKey:key];
}

@end
