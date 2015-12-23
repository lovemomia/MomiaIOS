//
//  Constants.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/4/18.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

//#define MO_DEBUG       1 // 调试开关 (0线上，1调试) (现在分target编译，定义到debug target的plist中了)

// API Domain
// 线上环境
#define MO_API_DOMAIN_OL            @"http://i.sogokids.com"
#define MO_HTTPS_API_DOMAIN_OL      @"https://i.sogokids.com"
#define MO_IMAGE_API_DOMAIN_OL      @"http://s.sogokids.com"

// 开发环境
#define MO_API_DOMAIN_DEV           @"http://i.momia.cn"
#define MO_HTTPS_API_DOMAIN_DEV     @"https://i.momia.cn"
#define MO_IMAGE_API_DOMAIN_DEV     @"http://s.momia.cn"

#if     MO_DEBUG == 0

#define MO_API_DOMAIN               MO_API_DOMAIN_OL
#define MO_HTTPS_API_DOMAIN         MO_HTTPS_API_DOMAIN_OL
#define MO_IMAGE_API_DOMAIN         MO_IMAGE_API_DOMAIN_OL

#define MO_SCHEME                   @"duola://"

#else

#define MO_API_DOMAIN               MO_API_DOMAIN_DEV
#define MO_HTTPS_API_DOMAIN         MO_HTTPS_API_DOMAIN_DEV
#define MO_IMAGE_API_DOMAIN         MO_IMAGE_API_DOMAIN_DEV

#define MO_SCHEME                   @"duoladebug://"

#endif

// url scheme拼接
#define MOURL_STRING(__pathAndParamsString__)   ([MO_SCHEME stringByAppendingString:__pathAndParamsString__])
#define MOURL(__pathAndParamsString__)          ([NSURL URLWithString:MOURL_STRING(__pathAndParamsString__)])

// App渠道
#define MO_APP_CHANNEL          @"appstore"


#define URL_HTTPS_APPEND_PATH(__path__) ([MO_HTTPS_API_DOMAIN stringByAppendingString:__path__])

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
#define MO_APP_ThemeColor                    (UIColorFromRGB(0x00c49d))

/**
 *  页面背景颜色
 */
#define MO_APP_VCBackgroundColor            (UIColorFromRGB(0xf1f1f1))

/**
 *  分割线颜色
 */
#define MO_APP_SeparatorColor            (UIColorFromRGB(0xdddddd))

/**
 *  字体颜色（红色）
 */
#define MO_APP_TextColor_red                    (UIColorFromRGB(0xFF6633))

/**
 *  字体颜色（灰色）
 */
#define MO_APP_TextColor_gray                    (UIColorFromRGB(0x737373))

// getui push dev
#define kAppId           @"0kPG75cb4s5GJmZMnEueR1"
#define kAppKey          @"fRdqHs15ak5zgCwTU00Ud6"
#define kAppSecret       @"xfIhi0VVz18TG9Qv1zXa93"

// getui push production
//#define kAppId           @"iMahVVxurw6BNr7XSn9EF2"
//#define kAppKey          @"yIPfqwq6OMAPp6dkqgLpG5"
//#define kAppSecret       @"G0aBqAD6t79JfzTB6Z5lo5"

// sina
#define kSinaAppKey         @"2849276776"
#define kSinaRedirectURI    @"https://api.weibo.com/oauth2/default.html"

// wechat
#define kWechatAppKey         @"wx50b2ac03c88ad6e7" //松果亲子
#define kWechatAppKey_QA      @"wxcf7b15b51d3b4e53" //哆啦亲子

// umeng
#define kUMengAppKey          @"55a317be67e58ea6470059ba"

// rong cloud
#define kRCIMAppKey          @"e5t4ouvptfowa"
#define kRCIMAppKey_QA       @"0vnjpoadnwp2z" //测试环境

