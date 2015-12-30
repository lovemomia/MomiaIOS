//
//  User.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/11/13.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "JSONModel.h"
#import "Child.h"

@protocol Child <NSObject>

@end

@interface User : JSONModel

@property (nonatomic, strong) NSNumber *uid;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString<Optional> *birthday;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString<Optional> *sex;
@property (nonatomic, strong) NSString<Optional> *mobile;
@property (nonatomic, strong) NSString<Optional> *address;
@property (nonatomic, strong) NSNumber<Optional> *city;
@property (nonatomic, strong) Child<Optional> *bigChild;
@property (nonatomic, strong) NSArray<Child, Optional> *children;

@property (nonatomic, strong) NSString<Optional> *cover;
@property (nonatomic, strong) NSNumber *role;
@property (nonatomic, strong) NSArray<Optional> *imgs;

@end
