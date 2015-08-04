//
//  Account.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/25.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"
#import "Child.h"

@interface Account : JSONModel<NSCoding>

@property (nonatomic, strong) NSString<Optional> *token;

@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString<Optional> *birthday;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSNumber<Optional> *city;
@property (nonatomic, strong) Child<Optional> *bigChild;
@property (nonatomic, strong) NSArray *children;

- (void)save;

- (void)clear;

- (NSString *)ageWithDateOfBirth;

- (Child *)getBigChild;

@end
