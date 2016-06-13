//
//  URLMappingManager.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/4/24.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MOViewController.h"

@interface URLMappingManager : NSObject

+ (URLMappingManager *)sharedManager;

- (BOOL)handleOpenURL:(NSURL *)url byNav:(UINavigationController *)nav;

- (BOOL)openURL:(NSURL *)url byNav:(UINavigationController *)nav;

- (BOOL)presentURL:(NSURL *)url byParent:(UIViewController *)parent animated:(BOOL)animated;

- (UIViewController *)createControllerFromURL:(NSURL *)url;

@end
