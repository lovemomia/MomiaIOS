//
//  BaseModel.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/8.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "JSONModel.h"

@interface BaseModel : JSONModel

@property (assign, nonatomic) int errNo;
@property (strong, nonatomic) NSString *errMsg;
@property (assign, nonatomic) long long timestamp;

@end
