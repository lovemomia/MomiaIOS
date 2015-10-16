//
//  Child.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/3.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "Child.h"

@implementation Child

#pragma mark -
#pragma mark keyMapper

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"ids"
                                                       }];
}

- (void)encodeWithCoder:(NSCoder *)encoder//编码
{
    [encoder encodeObject:self.ids forKey:@"ids"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.sex forKey:@"sex"];
    [encoder encodeObject:self.birthday forKey:@"birthday"];
    [encoder encodeObject:self.avatar forKey:@"avatar"];
}

- (id)initWithCoder:(NSCoder *)decoder//解码
{
    self = [super init];
    if (self)
    {
        self.ids = [decoder decodeObjectForKey:@"ids"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.sex = [decoder decodeObjectForKey:@"sex"];
        self.birthday = [decoder decodeObjectForKey:@"birthday"];
        self.avatar = [decoder decodeObjectForKey:@"avatar"];
    }
    return self;
}

- (void)setIds:(NSNumber *)ids {
    _ids = ids;
}

- (void)setName:(NSString *)name {
    _name = name;
}

- (void)setSex:(NSString *)sex {
    _sex = sex;
}

- (void)setBirthday:(NSString *)birthday {
    _birthday = birthday;
}

- (void)setAvatar:(NSString *)avatar {
    _avatar = avatar;
}

- (NSMutableDictionary *)toNSDictionary {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:self.name forKey:@"name"];
    [dictionary setValue:self.sex forKey:@"sex"];
    [dictionary setValue:self.birthday forKey:@"birthday"];
    [dictionary setValue:self.avatar forKey:@"avatar"];
    
    return dictionary;
}

@end
