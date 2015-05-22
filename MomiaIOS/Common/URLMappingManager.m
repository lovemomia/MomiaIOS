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
        NSString *file = [[NSBundle mainBundle] pathForResource:@"scheme" ofType:@"plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:file];
        _urlMapping = dict;
    }
    return self;
}

// called by AppDelegate
- (void)handleOpenURL:(NSURL *)url byNav:(UINavigationController *)nav {
    [self openURL:url byNav:nav];
}

- (BOOL)openURL:(NSURL *)url byNav:(UINavigationController *)nav {
    MOViewController *controller = [self createControllerFromURL:url];
    if (controller == nil) {
        return NO;
    }
    [nav pushViewController:controller animated:YES];
    
    return YES;
}

- (BOOL)presentURL:(NSURL *)url byParent:(UIViewController *)parent animated:(BOOL)animated {
    MOViewController *controller = [self createControllerFromURL:url];
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

- (MOViewController *)createControllerFromURL:(NSURL *)url {
    NSDictionary *pageDic = [self parsePageWithURL:url];
    if (pageDic == nil) {
        NSLog(@"URLMapping fail (not found page with url:%@", url);
        return nil;
    }
    
    NSDictionary *params = [url queryDictionary];
    MOViewController *controller = [[NSClassFromString(pageDic[pageKeyController]) alloc]initWithParams:params];
    return controller;
}

@end
