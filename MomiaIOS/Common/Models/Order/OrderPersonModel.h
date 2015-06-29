//
//  OrderPersonModel.h
//  MomiaIOS
//
//  Created by Owen on 15/6/29.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"

@interface OrderPersonDataModel : JSONModel

@property(nonatomic,assign) NSInteger birthday;
@property(nonatomic,assign) NSInteger opId;
@property(nonatomic,assign) NSInteger idType;
@property(nonatomic,strong) NSString * name;
@property(nonatomic,strong) NSString * sex;
@property(nonatomic,strong) NSString * type;

@end

@protocol OrderPersonDataModel <NSObject>

@end

@interface OrderPersonModel : BaseModel

@property(nonatomic,strong) NSArray<OrderPersonDataModel> * data;

@end
