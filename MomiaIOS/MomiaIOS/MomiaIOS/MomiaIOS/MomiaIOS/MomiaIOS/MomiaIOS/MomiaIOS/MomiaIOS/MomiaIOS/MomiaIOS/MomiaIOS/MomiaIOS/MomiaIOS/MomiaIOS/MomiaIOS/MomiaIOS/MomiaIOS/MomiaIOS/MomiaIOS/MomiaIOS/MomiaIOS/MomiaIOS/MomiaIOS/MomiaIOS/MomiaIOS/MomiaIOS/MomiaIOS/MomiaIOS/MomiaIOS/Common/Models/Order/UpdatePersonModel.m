//
//  AddPersonModel.m
//  MomiaIOS
//
//  Created by Owen on 15/6/29.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "UpdatePersonModel.h"

@implementation UpdatePersonModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"upId"}];
}


@end

@implementation EditPersonModel

@end

