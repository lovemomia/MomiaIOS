//
//  CityManager.h
//  MomiaIOS
//
//  City管理器，主要负责本地选择城市配置相关
//
//  Created by Deng Jun on 15/6/29.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"

@protocol CityChangeListener <NSObject>

- (void)onCityChanged:(City *)newCity;

@end

@interface CityManager : NSObject

+ (instancetype)shareManager;

/**
 * 当前选择城市
 */
@property (nonatomic, strong) City *choosedCity;

/**
 * 添加城市切换监听；注：应与#removeCityChangeListener成对出现
 */
- (void)addCityChangeListener:(id<CityChangeListener>)listener;

- (void)removeCityChangeListener:(id<CityChangeListener>)listener;

- (void)chooseCity:(UIViewController *)currentController;

@end
