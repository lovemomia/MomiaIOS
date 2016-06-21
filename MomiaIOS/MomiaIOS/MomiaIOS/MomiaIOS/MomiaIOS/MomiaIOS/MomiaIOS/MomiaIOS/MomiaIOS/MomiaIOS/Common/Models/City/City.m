//
//  City.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/6/29.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "City.h"

@implementation City

#pragma mark -
#pragma mark keyMapper

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"ids"
                                                       }];
}

- (void)setIds:(NSNumber *)ids {
    _ids = ids;
}

- (void)setName:(NSString *)name {
    _name = name;
}

- (void)encodeWithCoder:(NSCoder *)encoder//编码
{
    [encoder encodeObject:self.ids forKey:@"ids"];
    [encoder encodeObject:self.name forKey:@"name"];
}

- (id)initWithCoder:(NSCoder *)decoder//解码
{
    self = [super init];
    if (self)
    {
        self.ids = [decoder decodeObjectForKey:@"ids"];
        self.name = [decoder decodeObjectForKey:@"name"];
    }
    return self;
}

@end
