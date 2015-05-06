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

- (BOOL)openURL:(NSURL *)url byNav:(UINavigationController *)nav {
    if (url == nil) {
        return NO;
    }
    
    NSString *host = [[url host] lowercaseString];
    NSDictionary *params = [url queryDictionary];
    
    NSDictionary *pageDic = self.urlMapping[host];
    if (pageDic == nil) {
        return NO;
    }
    
    [self pushController:pageDic[pageKeyController] withParams:params byNav:nav];
    
    return YES;
}

- (void)pushController:(NSString *)name withParams:(NSDictionary *)params byNav:(UINavigationController *)nav {
    MOViewController *controller = [[NSClassFromString(name) alloc]initWithParams:params];
    
    [nav pushViewController:controller animated:YES];
}

// called by AppDelegate
- (void)handleOpenURL:(NSURL *)url byNav:(UINavigationController *)nav {
    [self openURL:url byNav:nav];
}

@end
