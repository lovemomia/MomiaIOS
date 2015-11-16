//
//  LocationService.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/6/25.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "LocationService.h"

static const long kTimeExpire = 300; // 5min

BMKMapManager* _mapManager;
@interface LocationService()
@property (nonatomic, strong) NSMutableArray *listeners;
@property (nonatomic, assign) long cachedTime;
@property (nonatomic, strong) CLLocation *cachedLocation;
@end

@implementation LocationService

+ (instancetype)defaultService {
    static LocationService *__service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __service = [[self alloc] init];
    });
    return __service;
}

#pragma mark - baidu map delegate

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

- (BOOL)hasLocation {
    return self.location == nil ? NO : YES;
}

- (instancetype)init {
    if (self = [super init]) {
        // 百度地图
        _mapManager = [[BMKMapManager alloc]init];
        [_mapManager start:@"dnSVNUqriaNXYqhD6ATZQ2zF" generalDelegate:self];
        _locService = [[BMKLocationService alloc]init];
    }
    return self;
}

- (void)start {
    if (_status > STATUS_IDLE) {
        NSLog(@"location service: fail to start, status > 0");
        return;
    }
    
    long dTime = [[[NSDate alloc]init] timeIntervalSince1970] - self.cachedTime;
    if (dTime > 0 && dTime < kTimeExpire) {
        _status = STATUS_LOCATED;
        _location = _cachedLocation;
        [self dispatchChanged];
        NSLog(@"location service: use cached location");
        return;
    }
    
    NSLog(@"location service: start locate");
    
    //启动LocationService
    [_locService startUserLocationService];
    _locService.delegate = self;
    _status = STATUS_TRYING;
    [self dispatchChanged];
}

- (void)stop {
    [_locService stopUserLocationService];
    _locService.delegate = nil;
}

- (void)refresh {

}

- (void)dispatchChanged {
    if (self.listeners) {
        for (id<LocationChangeListener> listener in self.listeners) {
            [listener onLocationChange];
        }
    }
}

- (void)willStartLocatingUser {
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    _status = STATUS_LOCATED;
    _location = _cachedLocation = userLocation.location;
    _cachedTime = [[[NSDate alloc]init] timeIntervalSince1970];
    [self dispatchChanged];
    [self stop];
    NSLog(@"location service: lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
}

/**
 *在地图View停止定位后，会调用此函数
 */
- (void)didStopLocatingUser {
    NSLog(@"location service: stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error {
    _status = STATUS_FAIL;
    [self dispatchChanged];
    NSLog(@"location service: location error");
}

- (void)addListener:(id<LocationChangeListener>)listener {
    if (self.listeners == nil) {
        self.listeners = [[NSMutableArray alloc]init];
    }
    [self.listeners addObject:listener];
}

- (void)removeListener:(id<LocationChangeListener>)listener {
    if (self.listeners) {
        [self.listeners removeObject:listener];
    }
}

@end
