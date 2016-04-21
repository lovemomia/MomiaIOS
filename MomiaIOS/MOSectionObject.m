//
//  MOTableViewSectionObject.m
//  MomiaIOS
//
//  Created by mosl on 16/4/20.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "MOSectionObject.h"

@implementation MOSectionObject

-(instancetype)init:(NSInteger)type data:(id)data{
    if (self = [super init]) {
        self.Type = type;
        self.Data = data;
    }
    return self;
}

@end
