//
//  NSString+MOURLEncode.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/4/24.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MOURLEncode)

- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;

@end
