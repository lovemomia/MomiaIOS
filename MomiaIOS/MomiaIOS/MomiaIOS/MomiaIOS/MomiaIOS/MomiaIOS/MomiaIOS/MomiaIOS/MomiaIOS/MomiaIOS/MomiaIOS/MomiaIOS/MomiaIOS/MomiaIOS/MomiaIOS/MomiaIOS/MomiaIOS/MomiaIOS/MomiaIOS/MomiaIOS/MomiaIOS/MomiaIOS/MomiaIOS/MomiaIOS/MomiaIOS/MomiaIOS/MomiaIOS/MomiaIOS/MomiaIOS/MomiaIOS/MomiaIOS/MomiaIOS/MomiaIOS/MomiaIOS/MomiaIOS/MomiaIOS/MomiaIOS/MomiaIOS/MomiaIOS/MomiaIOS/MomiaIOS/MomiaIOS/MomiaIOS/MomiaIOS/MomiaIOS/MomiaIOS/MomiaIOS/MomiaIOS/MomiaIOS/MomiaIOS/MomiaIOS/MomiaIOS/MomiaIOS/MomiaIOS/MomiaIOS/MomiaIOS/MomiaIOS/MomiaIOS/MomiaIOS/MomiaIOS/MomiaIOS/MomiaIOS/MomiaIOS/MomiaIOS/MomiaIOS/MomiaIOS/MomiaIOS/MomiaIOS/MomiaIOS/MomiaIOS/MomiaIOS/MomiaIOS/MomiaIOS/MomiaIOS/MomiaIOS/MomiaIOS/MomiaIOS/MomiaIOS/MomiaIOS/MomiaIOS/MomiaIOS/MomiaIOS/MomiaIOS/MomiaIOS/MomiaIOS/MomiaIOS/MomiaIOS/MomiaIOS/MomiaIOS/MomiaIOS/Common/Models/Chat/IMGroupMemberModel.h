//
//  IMGroupMemberModel.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/12/7.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"
#import "User.h"

@protocol User <NSObject>
@end

@interface IMGroupMemberData : JSONModel
@property (nonatomic, strong) NSArray<User> *teachers;
@property (nonatomic, strong) NSArray<User> *customers;
@end

@interface IMGroupMemberModel : BaseModel
@property (nonatomic, strong) IMGroupMemberData *data;
@end
