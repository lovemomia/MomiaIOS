//
//  AddPersonModel.h
//  MomiaIOS
//
//  Created by Owen on 15/6/29.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"

@interface UpdatePersonModel : JSONModel

@property(nonatomic,strong) NSNumber<Optional> * upId;
@property(nonatomic,strong) NSString<Ignore> * type;
@property(nonatomic,strong) NSString * birthday;
@property(nonatomic,assign) NSInteger idType;
@property(nonatomic,strong) NSString<Optional> * idNo;
@property(nonatomic,strong) NSString * name;
@property(nonatomic,strong) NSString * sex;

@end

@interface EditPersonModel : BaseModel

@property(nonatomic,strong) UpdatePersonModel * data;

@end


