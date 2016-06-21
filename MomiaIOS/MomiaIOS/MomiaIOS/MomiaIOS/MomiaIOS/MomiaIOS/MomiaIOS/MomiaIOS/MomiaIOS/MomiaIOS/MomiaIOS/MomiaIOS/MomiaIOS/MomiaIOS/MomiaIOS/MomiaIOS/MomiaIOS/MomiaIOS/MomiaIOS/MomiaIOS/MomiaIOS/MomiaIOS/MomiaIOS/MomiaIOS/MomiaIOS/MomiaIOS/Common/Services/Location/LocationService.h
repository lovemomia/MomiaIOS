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
#import <BaiduMapAPI/BMapKit.h>

@protocol LocationChangeListener<NSObject>
- (void)onLocationChange;
@end

typedef enum {
    STATUS_FAIL = -1,
    STATUS_IDLE = 0,
    STATUS_TRYING = 1,
    STATUS_LOCATED = 2
} STATUS;

@interface LocationService : NSObject<BMKLocationServiceDelegate, BMKGeneralDelegate> {
    BMKLocationService* _locService;
}

/**
 *  获取location服务单例
 */
+ (instancetype)defaultService;

@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, assign) STATUS status;
@property (nonatomic, strong) City *locateCity;

- (BOOL)hasLocation;

- (void)start;

- (void)stop;

- (void)refresh;

- (void)addListener:(id<LocationChangeListener>)listener;

- (void)removeListener:(id<LocationChangeListener>)listener;

@end
