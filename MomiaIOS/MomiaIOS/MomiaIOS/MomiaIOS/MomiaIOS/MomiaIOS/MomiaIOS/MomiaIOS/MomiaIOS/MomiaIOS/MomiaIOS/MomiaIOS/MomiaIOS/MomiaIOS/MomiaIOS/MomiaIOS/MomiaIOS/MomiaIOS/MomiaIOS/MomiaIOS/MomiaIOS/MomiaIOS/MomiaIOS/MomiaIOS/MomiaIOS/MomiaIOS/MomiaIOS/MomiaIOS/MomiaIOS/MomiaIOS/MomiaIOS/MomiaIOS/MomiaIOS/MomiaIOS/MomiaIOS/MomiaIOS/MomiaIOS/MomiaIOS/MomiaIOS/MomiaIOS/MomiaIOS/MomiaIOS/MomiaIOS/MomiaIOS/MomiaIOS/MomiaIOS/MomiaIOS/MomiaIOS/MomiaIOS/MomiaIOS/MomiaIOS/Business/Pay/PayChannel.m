//
//  PayChannel.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/7.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "PayChannel.h"

@implementation PayChannel

-(instancetype)initWithType:(NSInteger)type title:(NSString *)title desc:(NSString *)desc icon:(NSString *)icon select:(BOOL)select {
    if (self = [super init]) {
        self.type = type;
        self.title = title;
        self.desc = desc;
        self.icon = icon;
        self.select = select;
    }
    return self;
}

@end
