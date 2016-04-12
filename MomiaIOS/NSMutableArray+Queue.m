//
//  NSMutableArray+Queue.m
//  MomiaIOS
//
//  Created by mosl on 16/4/12.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "NSMutableArray+Queue.h"

@implementation NSMutableArray (Queue)


-(id)deQueue{
    id obj = nil;
    if (self && self.count > 0) {
        obj = [self firstObject];
        [self removeObjectAtIndex:0];
    }
    return obj;
}
@end
