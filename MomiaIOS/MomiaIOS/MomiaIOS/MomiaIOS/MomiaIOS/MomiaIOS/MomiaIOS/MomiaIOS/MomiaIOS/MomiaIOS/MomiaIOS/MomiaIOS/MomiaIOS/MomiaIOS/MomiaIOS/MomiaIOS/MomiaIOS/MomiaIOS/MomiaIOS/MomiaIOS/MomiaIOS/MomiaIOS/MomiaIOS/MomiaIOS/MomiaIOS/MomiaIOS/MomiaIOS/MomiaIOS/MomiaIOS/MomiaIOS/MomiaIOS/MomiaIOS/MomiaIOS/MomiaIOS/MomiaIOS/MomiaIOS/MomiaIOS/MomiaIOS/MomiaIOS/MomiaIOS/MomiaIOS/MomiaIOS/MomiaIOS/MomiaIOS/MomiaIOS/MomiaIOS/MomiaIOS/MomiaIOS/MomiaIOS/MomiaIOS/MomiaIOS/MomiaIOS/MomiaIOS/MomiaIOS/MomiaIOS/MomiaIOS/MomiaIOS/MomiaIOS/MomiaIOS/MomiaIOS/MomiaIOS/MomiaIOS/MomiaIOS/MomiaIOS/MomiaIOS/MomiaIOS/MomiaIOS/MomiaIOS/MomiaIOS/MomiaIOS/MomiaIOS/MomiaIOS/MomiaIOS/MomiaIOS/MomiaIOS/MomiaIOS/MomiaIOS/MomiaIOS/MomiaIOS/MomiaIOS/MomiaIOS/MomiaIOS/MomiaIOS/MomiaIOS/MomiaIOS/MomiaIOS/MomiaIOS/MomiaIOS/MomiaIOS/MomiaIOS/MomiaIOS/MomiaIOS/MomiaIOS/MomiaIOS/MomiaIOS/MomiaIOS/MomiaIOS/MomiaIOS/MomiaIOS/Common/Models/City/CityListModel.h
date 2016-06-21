//
//  CityListModel.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/6/29.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol City
@end

@interface CityListModel : BaseModel

@property(nonatomic,strong) NSArray<City> * data;

@end
