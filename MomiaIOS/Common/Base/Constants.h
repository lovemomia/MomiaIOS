//
//  Constants.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/4/18.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

// API Domain
#define MO_API_DOMAIN @"http://m.api.momia.cn/"

// app info
#define MO_APP_VERSION ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])
#define MO_APP_NAME ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"])

// os version
#define MO_OS_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue])
#define isCurrentDeviceSystemVersionLater(__Version__)      (MO_OS_VERSION >= (__Version__))

#define MO_SharedAppDelegate ((AppDelegate *)([UIApplication sharedApplication].delegate))

// RGB颜色
#define UIColorFromRGB(rgbValue) ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0])

#define UIColorFromRGBA(rgbValue, _alpha_) [UIColor colorWithRed:((float)((rgbValue &0xFF0000) >> 16))/255.0 green:((float)((rgbValue &0xFF00) >> 8))/255.0 blue:((float)(rgbValue &0xFF))/255.0 alpha:_alpha_]

// 是否为4寸屏
#define isDeviceiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640.0, 1136.0), [[UIScreen mainScreen] currentMode].size) : NO)

// 屏幕宽度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
// 屏幕高度
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

/**
 *  NavigationBar背景色
 */
#define MO_APP_NaviColor                    (UIColorFromRGB(0xFF1493))

/**
 *  页面背景颜色
 */
#define MO_APP_VCBackgroundColor            (UIColorFromRGB(0xEEEEEE))
