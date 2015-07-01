//
//  Constants.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/4/18.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

// API Domain
// 线上环境
#define MO_API_DOMAIN_OL  @"http://i.momia.cn"
// 开发环境
#define MO_API_DOMAIN_DEV @"http://dev.momia.cn"

#ifndef __OPTIMIZE__
#define MO_API_DOMAIN MO_API_DOMAIN_OL
#else
#define MO_API_DOMAIN MO_API_DOMAIN_DEV
#endif



// 请求url拼接
#define URL_APPEND_PATH(__path__)  ([MO_API_DOMAIN stringByAppendingString:__path__])

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


// 文章内容行间距
#define MO_LABEL_LINE_SPACE 5

/**
 *  NavigationBar背景色
 */
#define MO_APP_ThemeColor                    (UIColorFromRGB(0x1ebba6))

/**
 *  页面背景颜色
 */
#define MO_APP_VCBackgroundColor            (UIColorFromRGB(0xf1f1f1))

/**
 *  字体颜色（灰色）
 */
#define MO_APP_TextColor_gray                    (UIColorFromRGB(0x737373))

// getui push dev
#define kAppId           @"xHJWU4TNcm7qaq0GzMNwg7"
#define kAppKey          @"BPjUJH4Z8a9d4pSfv9AWA2"
#define kAppSecret       @"gRWoi5S1hv5gkaJhrGXYs9"

// getui push production
//#define kAppId           @"iMahVVxurw6BNr7XSn9EF2"
//#define kAppKey          @"yIPfqwq6OMAPp6dkqgLpG5"
//#define kAppSecret       @"G0aBqAD6t79JfzTB6Z5lo5"

// sina
#define kSinaAppKey         @"2849276776"
#define kSinaRedirectURI    @"https://api.weibo.com/oauth2/default.html"

// wechat
#define kWechatAppKey         @"wxf4b4b8411a1c7b77"
