//
//  OrderPerson.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/7.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "JSONModel.h"

@interface OrderPerson : JSONModel

@property(nonatomic,strong) NSString * birthday;
@property(nonatomic,assign) NSInteger opId;
@property(nonatomic,strong) NSString * name;
@property(nonatomic,strong) NSString * sex;
@property(nonatomic,strong) NSString * type;

@end
