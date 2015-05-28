//
//  Account.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/25.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "Account.h"

@implementation Account

- (void)setUserId:(NSInteger)userId {
    _userId = userId;
    [self save];
}

- (void)setToken:(NSString *)token {
    _token = token;
    [self save];
}

- (void)setAddress:(NSString *)address {
    _address = address;
    [self save];
}

- (void)setBabyAge:(NSString *)babyAge {
    _babyAge = babyAge;
    [self save];
}

- (void)setBabySex:(NSString *)babySex {
    _babySex = babySex;
    [self save];
}

- (void)setNickName:(NSString *)nickName {
    _nickName = nickName;
    [self save];
}

- (void)setPhone:(NSString *)phone {
    _phone = phone;
    [self save];
}

- (void)setPicUrl:(NSString *)picUrl {
    _picUrl = picUrl;
    [self save];
}

- (void)setQqNo:(NSString<Optional> *)qqNo {
    _qqNo = qqNo;
    [self save];
}

- (void)setWechatNo:(NSString *)wechatNo {
    _wechatNo = wechatNo;
    [self save];
}

- (void)setWeiboNo:(NSString *)weiboNo {
    _weiboNo = weiboNo;
    [self save];
}


- (void)encodeWithCoder:(NSCoder *)encoder//编码
{
    [encoder encodeInteger:self.userId forKey:@"userId"];
    [encoder encodeObject:self.token forKey:@"token"];
    [encoder encodeObject:self.address forKey:@"address"];
    [encoder encodeObject:self.babyAge forKey:@"babyAge"];
    [encoder encodeObject:self.babySex forKey:@"babySex"];
    [encoder encodeObject:self.nickName forKey:@"nickName"];
    [encoder encodeObject:self.phone forKey:@"phone"];
    [encoder encodeObject:self.picUrl forKey:@"picUrl"];
    [encoder encodeObject:self.qqNo forKey:@"qqNo"];
    [encoder encodeObject:self.wechatNo forKey:@"wechatNo"];
    [encoder encodeObject:self.weiboNo forKey:@"weiboNo"];
}

- (id)initWithCoder:(NSCoder *)decoder//解码
{
    self = [super init];
    if (self)
    {
        self.userId = [decoder decodeIntegerForKey:@"userId"];
        self.token = [decoder decodeObjectForKey:@"token"];
        self.address = [decoder decodeObjectForKey:@"address"];
        self.babyAge = [decoder decodeObjectForKey:@"babyAge"];
        self.babySex = [decoder decodeObjectForKey:@"babySex"];
        self.nickName = [decoder decodeObjectForKey:@"nickName"];
        self.phone = [decoder decodeObjectForKey:@"phone"];
        self.picUrl = [decoder decodeObjectForKey:@"picUrl"];
        self.qqNo = [decoder decodeObjectForKey:@"qqNo"];
        self.wechatNo = [decoder decodeObjectForKey:@"wechatNo"];
        self.weiboNo = [decoder decodeObjectForKey:@"weiboNo"];
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
