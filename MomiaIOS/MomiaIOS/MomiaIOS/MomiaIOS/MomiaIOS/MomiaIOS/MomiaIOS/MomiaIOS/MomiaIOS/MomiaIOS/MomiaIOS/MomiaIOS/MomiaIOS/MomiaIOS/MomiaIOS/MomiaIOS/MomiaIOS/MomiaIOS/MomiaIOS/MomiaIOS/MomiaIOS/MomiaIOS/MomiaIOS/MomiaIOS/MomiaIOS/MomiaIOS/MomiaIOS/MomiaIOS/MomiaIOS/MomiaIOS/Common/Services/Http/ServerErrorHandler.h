//
//  ServerErrorHandler.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/3.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerErrorHandler : NSObject

/**
 *  获取Http服务单例
 */
+ (instancetype)defaultHandler;

- (BOOL)handlerError:(NSError *)error ;

@end
