//
//  ConfigService.h
//  MomiaIOS
//
//  配置服务，提供服务器配置开关的读取接口
//
//  Created by Deng Jun on 15/8/3.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ConfigChangeListener<NSObject>

- (void)onConfigChange:(NSString *)key from:(NSObject *)from to:(NSObject *)to;

@end

@interface ConfigService : NSObject

/**
 *  获取config服务单例
 */
+ (instancetype)defaultService;

- (void)refresh;

- (BOOL)getBoolean:(NSString *)key defaultValue:(BOOL)def;

- (NSInteger)getInteger:(NSString *)key defaultValue:(NSInteger)def;

- (CGFloat)getFloat:(NSString *)key defaultValue:(CGFloat)def;

- (NSString *)getString:(NSString *)key defaultValue:(NSString *)def;

- (NSDictionary *)getDictionary:(NSString *)key;

- (void)addListener:(id<ConfigChangeListener>)listener forKey:(NSString *)key;

- (void)removeListener:(id<ConfigChangeListener>)listener forKey:(NSString *)key;


@end
