//
//  RNCommon.h
//  MomiaIOS
//
//  Created by Deng Jun on 16/5/16.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCTBridgeModule.h"
#import "RCTRootView.h"

@interface RNCommon : NSObject<RCTBridgeModule>

+ (RCTRootView *)createRCTViewWithBundleURL:(NSURL *)bundleURL
                       moduleName:(NSString *)moduleName
                initialProperties:(NSDictionary *)initialProperties
                    launchOptions:(NSDictionary *)launchOptions;

@end
