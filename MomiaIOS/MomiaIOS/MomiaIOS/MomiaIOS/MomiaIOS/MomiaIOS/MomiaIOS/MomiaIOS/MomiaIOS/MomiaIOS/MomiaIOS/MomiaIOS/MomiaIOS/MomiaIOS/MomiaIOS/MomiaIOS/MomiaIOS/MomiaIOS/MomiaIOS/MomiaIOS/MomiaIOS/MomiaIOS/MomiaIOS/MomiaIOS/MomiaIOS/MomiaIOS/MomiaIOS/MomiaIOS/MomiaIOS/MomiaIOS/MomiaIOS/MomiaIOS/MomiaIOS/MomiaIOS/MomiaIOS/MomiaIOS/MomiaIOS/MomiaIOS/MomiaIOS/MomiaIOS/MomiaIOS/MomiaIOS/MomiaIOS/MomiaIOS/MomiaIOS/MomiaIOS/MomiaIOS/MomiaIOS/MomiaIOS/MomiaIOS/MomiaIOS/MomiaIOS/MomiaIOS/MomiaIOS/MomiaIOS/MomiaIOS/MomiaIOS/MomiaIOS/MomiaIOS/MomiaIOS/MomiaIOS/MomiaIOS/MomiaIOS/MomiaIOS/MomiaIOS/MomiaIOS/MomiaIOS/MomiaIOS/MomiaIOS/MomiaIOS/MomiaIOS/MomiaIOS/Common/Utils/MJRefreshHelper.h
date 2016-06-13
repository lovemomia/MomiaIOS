//
//  MJRefreshHelper.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/11/10.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJRefresh.h"

@interface MJRefreshHelper : NSObject

+ (MJRefreshGifHeader *)createGifHeaderWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

@end
