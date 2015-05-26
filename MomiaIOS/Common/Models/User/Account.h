//
//  Account.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/25.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"

@interface Account : JSONModel<NSCoding>

@property (nonatomic, assign) int userId;
@property (nonatomic, strong) NSString *token;

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *babyAge;
@property (nonatomic, strong) NSString *babySex;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *picUrl;

@property (nonatomic, strong) NSString<Optional> *qqNo;
@property (nonatomic, strong) NSString *wechatNo;
@property (nonatomic, strong) NSString *weiboNo;

@end
