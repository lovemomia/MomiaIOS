//
//  AddPersonModel.h
//  MomiaIOS
//
//  Created by Owen on 15/6/29.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "JSONModel.h"

@interface AddPersonModel : JSONModel

@property(nonatomic,strong) NSString * birthday;
@property(nonatomic,assign) NSInteger idType;
@property(nonatomic,strong) NSString * idNo;
@property(nonatomic,strong) NSString * name;
@property(nonatomic,strong) NSString * sex;

@end

