//
//  URLMappingManager.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/4/24.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "URLMappingManager.h"
#import "NSURL+MOURL.h"
#import "MOViewController.h"
#import "Constants.h"
#import "LoginViewController.h"
#import "MONavigationController.h"

#define INIT_VIEW(name) [[name alloc] initWithNibName:@#name bundle:nil]

NSString * const pageKeyController    = @"controller";
NSString * const pageKeyNeedLogin     = @"needlogin";
NSString * const pageKeyDesc          = @"desc";

@interface URLMappingManager()

@property (strong, nonatomic) NSDictionary *urlMapping;

@end

@implementation URLMappingManager

+ (URLMappingManager *)sharedManager {
    static URLMappingManager *_mappingManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _mappingManager = [[URLMappingManager alloc] init];
    });
    
    return _mappingManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *file = [[NSBundle mainBundle] pathForResource:@"mapping" ofType:@"plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:file];
        _urlMapping = dict;
    }
    return self;
}

// called by AppDelegate
- (BOOL)handleOpenURL:(NSURL *)url byNav:(UINavigationController *)nav {
    return [self openURL:url byNav:nav];
}

- (BOOL)openURL:(NSURL *)url byNav:(UINavigationController *)nav {
    NSDictionary *pageDic = [self parsePageWithURL:url];
    if (pageDic == nil) {
        NSLog(@"URLMapping fail (not found page with url:%@", url);
        return NO;
    }
    
    // 判断是否需要登录
    BOOL needLogin = [[pageDic objectForKey:pageKeyNeedLogin] boolValue];
    if (needLogin && ![[AccountService defaultService] isLogin]) {
        UIViewController *currentController = [nav.viewControllers objectAtIndex:[nav.viewControllers count] - 1];
        LoginViewController *controller = [[LoginViewController alloc]initWithParams:nil];
        
        controller.loginSuccessBlock = ^(){
            [currentController dismissViewControllerAnimated:NO completion:nil];
            NSDictionary *params = [url queryDictionary];
            UIViewController *controller = [[NSClassFromString(pageDic[pageKeyController]) alloc]initWithParams:params];
            [nav pushViewController:controller animated:YES];
        };
        controller.loginFailBlock = ^(NSInteger code, NSString* message){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        };
        controller.loginCancelBlock = ^(){
            [currentController dismissViewControllerAnimated:YES completion:nil];
        };
        
        MONavigationController *navController = [[MONavigationController alloc]initWithRootViewController:controller];
        [currentController presentViewController:navController animated:YES completion:nil];
        
    } else {
        NSDictionary *params = [url queryDictionary];
        UIViewController *controller = [[NSClassFromString(pageDic[pageKeyController]) alloc]initWithParams:params];
        if (controller == nil) {
            return NO;
        }
        [nav pushViewController:controller animated:YES];
    }
    
    return YES;
}

- (BOOL)presentURL:(NSURL *)url byParent:(UIViewController *)parent animated:(BOOL)animated {
    UIViewController *controller = [self createControllerFromURL:url];
    if (controller == nil) {
        return NO;
    }
    [parent presentViewController:controller animated:animated completion:nil];
    return YES;
}

- (NSDictionary *)parsePageWithURL:(NSURL *)url {
    if (url == nil) {
        return nil;
    }
    NSString *host = [[url host] lowercaseString];
    NSDictionary *pageDic = self.urlMapping[host];
    return pageDic;
}

- (UIViewController *)createControllerFromURL:(NSURL *)url {
    NSDictionary *pageDic = [self parsePageWithURL:url];
    if (pageDic == nil) {
        NSLog(@"URLMapping fail (not found page with url:%@", url);
        return nil;
    }
    
    NSDictionary *params = [url queryDictionary];
    UIViewController *controller = [[NSClassFromString(pageDic[pageKeyController]) alloc]initWithParams:params];
    return controller;
}

@end
