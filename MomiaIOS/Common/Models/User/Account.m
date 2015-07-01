//
//  Account.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/25.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "Account.h"

@implementation Account

- (void)setToken:(NSString *)token {
    _token = token;
    [self save];
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

- (void)setCity:(NSString *)city {
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

- (void)encodeWithCoder:(NSCoder *)encoder//编码
{
    [encoder encodeObject:self.token forKey:@"token"];
    [encoder encodeObject:self.address forKey:@"address"];
    [encoder encodeObject:self.avatar forKey:@"avatar"];
    [encoder encodeObject:self.birthday forKey:@"birthday"];
    [encoder encodeObject:self.city forKey:@"city"];
    [encoder encodeObject:self.mobile forKey:@"mobile"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.nickName forKey:@"nickName"];
    [encoder encodeObject:self.sex forKey:@"sex"];
}

- (id)initWithCoder:(NSCoder *)decoder//解码
{
    self = [super init];
    if (self)
    {
        self.token = [decoder decodeObjectForKey:@"token"];
        self.address = [decoder decodeObjectForKey:@"address"];
        self.avatar = [decoder decodeObjectForKey:@"avatar"];
        self.birthday = [decoder decodeObjectForKey:@"birthday"];
        self.city = [decoder decodeObjectForKey:@"city"];
        self.mobile = [decoder decodeObjectForKey:@"mobile"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.nickName = [decoder decodeObjectForKey:@"nickName"];
        self.sex = [decoder decodeObjectForKey:@"sex"];
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

@end
