//
//  Child.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/3.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "JSONModel.h"

@interface Child : JSONModel<NSCoding>

@property (nonatomic, strong) NSNumber *ids;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *avatar;

- (NSMutableDictionary *)toNSDictionary;

- (NSString *)ageWithDateOfBirth;

@end
