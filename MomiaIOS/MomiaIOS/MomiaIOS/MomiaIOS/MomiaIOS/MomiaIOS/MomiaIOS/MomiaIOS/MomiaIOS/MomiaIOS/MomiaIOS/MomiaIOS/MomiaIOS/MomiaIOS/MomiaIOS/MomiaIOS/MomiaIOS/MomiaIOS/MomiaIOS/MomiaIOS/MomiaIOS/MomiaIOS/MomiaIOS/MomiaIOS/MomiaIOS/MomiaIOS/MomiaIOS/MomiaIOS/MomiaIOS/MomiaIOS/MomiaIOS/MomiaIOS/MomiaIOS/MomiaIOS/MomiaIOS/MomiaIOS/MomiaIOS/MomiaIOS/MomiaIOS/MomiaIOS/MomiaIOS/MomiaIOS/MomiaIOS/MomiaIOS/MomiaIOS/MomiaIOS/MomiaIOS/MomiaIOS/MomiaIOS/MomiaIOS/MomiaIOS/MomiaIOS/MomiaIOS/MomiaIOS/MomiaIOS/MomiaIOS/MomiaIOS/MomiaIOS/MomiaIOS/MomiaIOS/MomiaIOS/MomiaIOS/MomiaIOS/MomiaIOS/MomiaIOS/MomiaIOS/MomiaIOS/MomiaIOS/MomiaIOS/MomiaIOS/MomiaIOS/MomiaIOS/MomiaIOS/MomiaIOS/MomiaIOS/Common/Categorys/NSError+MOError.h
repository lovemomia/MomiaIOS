//
//  NSError+MOError.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/27.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (MOError)

@property (nonatomic, strong) NSString *message;

- (instancetype)initWithCode:(NSInteger)code message:(NSString *)message;

@end
