//
//  MOTableViewSectionObject.h
//  MomiaIOS
//
//  Created by mosl on 16/4/20.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOSectionObject : NSObject

@property (nonatomic, assign) NSInteger Type;
@property (nonatomic, strong) id Data;

-(instancetype)init:(NSInteger)type data:(id)data;

@end
