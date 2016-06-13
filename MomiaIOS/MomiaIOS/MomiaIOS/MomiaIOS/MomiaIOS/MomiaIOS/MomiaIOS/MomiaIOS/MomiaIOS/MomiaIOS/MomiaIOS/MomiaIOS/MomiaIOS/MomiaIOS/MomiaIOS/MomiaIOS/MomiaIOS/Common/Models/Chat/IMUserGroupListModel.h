//
//  IMUserGroupListModel.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/12/4.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"

@interface IMUserGroup : JSONModel
@property (nonatomic, strong) NSNumber *groupId;
@property (nonatomic, strong) NSString *groupName;
@property (nonatomic, strong) NSString *addTime;
@property (nonatomic, strong) NSString *tips;
@end

@protocol IMUserGroup <NSObject>
@end

@interface IMUserGroupListModel : BaseModel
@property (nonatomic, strong) NSArray<IMUserGroup, Optional> *data;
@end
