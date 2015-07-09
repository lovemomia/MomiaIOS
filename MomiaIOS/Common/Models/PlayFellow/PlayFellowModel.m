//
//  PlayFellowModel.m
//  MomiaIOS
//
//  Created by Owen on 15/7/7.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "PlayFellowModel.h"

@implementation PlayFellowChildrenModel

+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"childrenId"}];
}

@end

@implementation PlayFellowCustomersModel

+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"customersId"}];
}

@end

@implementation PlayFellowListModel

@end

@implementation PlayFellowDataModel

@end

@implementation PlayFellowModel

@end
