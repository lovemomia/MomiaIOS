//
//  LocationService.h
//  MomiaIOS
//
//  定位服务，提供位置相关信息
//
//  Created by Deng Jun on 15/6/25.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"

@interface LocationService : NSObject

/**
 *  获取location服务单例
 */
+ (instancetype)defaultService;

@property (nonatomic, strong) City *locateCity;

@end
