//
//  IMGroupModel.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/12/4.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"

@interface IMGroup : JSONModel
@property (nonatomic, strong) NSNumber *groupId;
@property (nonatomic, strong) NSString *groupName;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *tips;
@property (nonatomic, strong) NSString *route; //路线
@end

@interface IMGroupModel : BaseModel
@property (nonatomic, strong) IMGroup *data;
@end
