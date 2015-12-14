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

- (NSString *)ageWithDateOfBirth {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* date = [inputFormatter dateFromString:self.birthday];
    
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
