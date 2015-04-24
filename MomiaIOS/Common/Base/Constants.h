//
//  Constants.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/4/18.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#define MO_API_DOMAIN @"http://m.api.momia.cn/"

#define MO_APP_VERSION ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])
#define MO_APP_NAME ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"])

#define MO_OS_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue])
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

#define MO_SharedAppDelegate ((AppDelegate *)([UIApplication sharedApplication].delegate))