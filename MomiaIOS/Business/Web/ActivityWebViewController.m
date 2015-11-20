//
//  ActivityWebViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/6.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ActivityWebViewController.h"

@interface ActivityWebViewController ()

@end

@implementation ActivityWebViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([[AccountService defaultService] isLogin]) {
        [self setCookie];
    } else {
        [self deleteCookie];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//设置cookie
- (void)setCookie{
    NSMutableDictionary *cookiePropertiesUser = [NSMutableDictionary dictionary];
    if ([[AccountService defaultService] isLogin]) {
        [cookiePropertiesUser setObject:@"utoken" forKey:NSHTTPCookieName];
        [cookiePropertiesUser setObject:[AccountService defaultService].account.token forKey:NSHTTPCookieValue];
    }
    if (MO_DEBUG == 0) {
        [cookiePropertiesUser setObject:@"m.sogokids.com" forKey:NSHTTPCookieDomain];
    } else {
        [cookiePropertiesUser setObject:@"m.momia.cn" forKey:NSHTTPCookieDomain];
    }
    [cookiePropertiesUser setObject:@"/" forKey:NSHTTPCookiePath];
    [cookiePropertiesUser setObject:@"0" forKey:NSHTTPCookieVersion];
    
    // set expiration to one month from now or any NSDate of your choosing
    // this makes the cookie sessionless and it will persist across web sessions and app launches
    /// if you want the cookie to be destroyed when your app exits, don't set this
    [cookiePropertiesUser setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
    
    NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookiePropertiesUser];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser];
}

//清除cookie
- (void)deleteCookie{
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookieAry = [cookieJar cookiesForURL: [NSURL URLWithString: MO_DEBUG == 0 ? @"http://m.sogokids.com" : @"http://m.momia.cn"]];
    
    for (cookie in cookieAry) {
        [cookieJar deleteCookie: cookie];
    }
}

@end
