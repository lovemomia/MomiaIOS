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

@interface ConfigService : NSObject

/**
 *  获取config服务单例
 */
+ (instancetype)defaultService;

@end
