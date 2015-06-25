//
//  Account.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/25.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"

@interface Account : JSONModel<NSCoding>

@property (nonatomic, strong) NSString *token;

@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, assign) long birthday;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *address;

@property (nonatomic, assign) int cityId;

- (void)save;

- (void)clear;

@end
