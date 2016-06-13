//
//  NSError+MOError.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/27.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "NSError+MOError.h"
#import <objc/runtime.h>

static void * MessageKey = (void *)@"MessageKey";

@implementation NSError (MOError)
@dynamic message;

- (instancetype)initWithCode:(NSInteger)code message:(NSString *)message {
    if (self = [self initWithDomain:@"" code:code userInfo:nil]) {
        self.message = message;
    }
    return self;
}

- (void)setMessage:(NSString *)msg {
    objc_setAssociatedObject(self, MessageKey, msg, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)message {
    return objc_getAssociatedObject(self, MessageKey);
}

@end
