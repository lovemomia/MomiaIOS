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

- (void)setToken:(NSString *)token {
    if (token.length > 0) {
        _token = token;
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
    [encoder encodeObject:self.token forKey:@"token"];
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
        self.bigChild = [decoder decodeObjectForKey:@"bigChild"];
        self.children = [decoder decodeObjectForKey:@"children"];
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
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* date = [inputFormatter dateFromString:child.birthday];
    
    // 出生日期转换 年月日
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    NSInteger brithDateYear  = [components1 year];
    NSInteger brithDateDay   = [components1 day];
    NSInteger brithDateMonth = [components1 month];
    
    // 获取系统当前 年月日
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger currentDateYear  = [components2 year];
    NSInteger currentDateDay   = [components2 day];
    NSInteger currentDateMonth = [components2 month];
    
    // 几岁
    NSInteger iAge = currentDateYear - brithDateYear - 1;
    if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
        iAge++;
    }
    
    if (iAge > 0) {
        if (iAge == 1 && currentDateMonth < brithDateMonth) {
            NSInteger month = 12 + currentDateMonth - brithDateMonth;
            return [NSString stringWithFormat:@"%d个月", (int)month];
        } else {
            return [NSString stringWithFormat:@"%d岁", (int)iAge];
        }
    }
    
    // 几个月
    NSInteger month = currentDateMonth - brithDateMonth;
    return [NSString stringWithFormat:@"%d个月", (int)month];
}

@end
