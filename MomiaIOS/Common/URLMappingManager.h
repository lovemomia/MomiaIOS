//
//  URLMappingManager.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/4/24.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface URLMappingManager : NSObject

+ (URLMappingManager *)mappingManager;

- (BOOL)openURL:(NSURL *)url byNav:(UINavigationController *)nav;

- (void)handleOpenURL:(NSURL *)url byNav:(UINavigationController *)nav;

@end
