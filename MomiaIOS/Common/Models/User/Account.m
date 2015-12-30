//
//  Account.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/25.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "Account.h"
#import "Child.h"

@implementation Account

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"uid"
                                                       }];
}

- (void)setToken:(NSString *)token {
    if (token.length > 0) {
        _token = token;
        [self save];
    }
}

- (void)setImToken:(NSString *)imToken {
    if (imToken.length > 0) {
        _imToken = imToken;
        [self save];
    }
}

- (void)setAddress:(NSString *)address {
    _address = address;
    [self save];
}

- (void)setAvatar:(NSString *)avatar {
    _avatar = avatar;
    [self save];
}

- (void)setBirthday:(NSString *)birthday {
    _birthday = birthday;
    [self save];
}

- (void)setCity:(NSNumber *)city {
    _city = city;
    [self save];
}

- (void)setMobile:(NSString *)mobile {
    _mobile = mobile;
    [self save];
}

- (void)setName:(NSString *)name {
    _name = name;
    [self save];
}

- (void)setNickName:(NSString *)nickName {
    _nickName = nickName;
    [self save];
}

- (void)setSex:(NSString *)sex {
    _sex = sex;
    [self save];
}

- (void)setBigChild:(Child *)bigChild {
    _bigChild = bigChild;
    [self save];
}

- (Child *)getBigChild {
    if (self.bigChild == nil) {
        NSArray *children = [self children];
        if (children.count > 0) {
            self.bigChild = [children objectAtIndex:0];
        }
    }
    return self.bigChild;
}

//- (void)setChildren:(NSArray *)children {
//    _children = children;
//    [self save];
//}

- (NSArray *)children {
    NSArray *dicArray = _children;
    NSMutableArray *childArray = [NSMutableArray new];
    for (NSDictionary *dic in dicArray) {
        Child *child = [[Child alloc]initWithDictionary:dic error:nil];
        if (child != nil) {
            [childArray addObject:child];
        }
    }
    return childArray;
}

- (void)encodeWithCoder:(NSCoder *)encoder//编码
{
    [encoder encodeObject:self.uid forKey:@"uid"];
    [encoder encodeObject:self.token forKey:@"token"];
    [encoder encodeObject:self.imToken forKey:@"imToken"];
    [encoder encodeObject:self.address forKey:@"address"];
    [encoder encodeObject:self.avatar forKey:@"avatar"];
    [encoder encodeObject:self.birthday forKey:@"birthday"];
    [encoder encodeObject:self.city forKey:@"city"];
    [encoder encodeObject:self.mobile forKey:@"mobile"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.nickName forKey:@"nickName"];
    [encoder encodeObject:self.sex forKey:@"sex"];
    [encoder encodeObject:self.bigChild forKey:@"bigChild"];
    [encoder encodeObject:self.children forKey:@"children"];
    [encoder encodeObject:self.cover forKey:@"cover"];
    [encoder encodeObject:self.role forKey:@"role"];
}

- (id)initWithCoder:(NSCoder *)decoder//解码
{
    self = [super init];
    if (self)
    {
        self.uid = [decoder decodeObjectForKey:@"uid"];
        self.token = [decoder decodeObjectForKey:@"token"];
        self.imToken = [decoder decodeObjectForKey:@"imToken"];
        self.address = [decoder decodeObjectForKey:@"address"];
        self.avatar = [decoder decodeObjectForKey:@"avatar"];
        self.birthday = [decoder decodeObjectForKey:@"birthday"];
        self.city = [decoder decodeObjectForKey:@"city"];
        self.mobile = [decoder decodeObjectForKey:@"mobile"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.nickName = [decoder decodeObjectForKey:@"nickName"];
        self.sex = [decoder decodeObjectForKey:@"sex"];
        self.bigChild = [decoder decodeObjectForKey:@"bigChild"];
        self.children = [decoder decodeObjectForKey:@"children"];
        self.cover = [decoder decodeObjectForKey:@"cover"];
        self.role = [decoder decodeObjectForKey:@"role"];
    }
    return self;
}

- (void)save {
    NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSUserDefaults *myDefault =[NSUserDefaults standardUserDefaults];
    [myDefault setObject:archiveData forKey:@"account"];
}

- (void)clear {
    
}

- (NSString *)ageWithDateOfBirth
{
    if ([self getBigChild] == nil) {
        return @"?岁";
    }
    
    Child *child = [self getBigChild];
    
    return [NSString stringWithFormat:@"%@孩%@", child.sex, [child ageWithDateOfBirth]];
}

@end
