//
//  HomeTopic.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/9.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "JSONModel.h"

@interface HomeTopic : JSONModel

@property (assign, nonatomic) int type;
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* photo;
@property (strong, nonatomic) NSString* action;

@end
