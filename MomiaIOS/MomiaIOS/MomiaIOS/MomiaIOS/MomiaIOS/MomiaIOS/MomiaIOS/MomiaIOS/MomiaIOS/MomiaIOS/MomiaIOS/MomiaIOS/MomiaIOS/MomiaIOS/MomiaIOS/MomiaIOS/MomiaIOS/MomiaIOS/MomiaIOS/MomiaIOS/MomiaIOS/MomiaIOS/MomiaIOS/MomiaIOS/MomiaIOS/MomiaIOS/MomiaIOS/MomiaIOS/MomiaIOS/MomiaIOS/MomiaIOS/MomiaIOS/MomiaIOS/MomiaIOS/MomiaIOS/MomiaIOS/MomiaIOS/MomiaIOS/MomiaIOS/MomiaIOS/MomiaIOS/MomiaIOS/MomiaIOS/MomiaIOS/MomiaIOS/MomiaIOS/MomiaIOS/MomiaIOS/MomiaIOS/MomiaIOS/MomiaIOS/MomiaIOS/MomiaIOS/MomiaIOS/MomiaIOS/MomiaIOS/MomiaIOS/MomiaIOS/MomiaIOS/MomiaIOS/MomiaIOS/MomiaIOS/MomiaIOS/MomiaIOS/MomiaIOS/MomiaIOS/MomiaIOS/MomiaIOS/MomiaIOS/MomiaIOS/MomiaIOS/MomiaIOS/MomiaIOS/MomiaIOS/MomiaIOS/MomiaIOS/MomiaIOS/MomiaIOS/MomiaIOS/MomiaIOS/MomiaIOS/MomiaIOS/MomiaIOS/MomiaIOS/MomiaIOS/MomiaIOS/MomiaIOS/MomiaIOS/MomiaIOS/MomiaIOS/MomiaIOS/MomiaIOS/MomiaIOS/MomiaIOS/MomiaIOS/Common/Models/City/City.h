//
//  City.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/6/29.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : JSONModel<NSCoding>

@property (nonatomic, strong) NSNumber *ids;
@property (nonatomic, strong) NSString *name;

@end
