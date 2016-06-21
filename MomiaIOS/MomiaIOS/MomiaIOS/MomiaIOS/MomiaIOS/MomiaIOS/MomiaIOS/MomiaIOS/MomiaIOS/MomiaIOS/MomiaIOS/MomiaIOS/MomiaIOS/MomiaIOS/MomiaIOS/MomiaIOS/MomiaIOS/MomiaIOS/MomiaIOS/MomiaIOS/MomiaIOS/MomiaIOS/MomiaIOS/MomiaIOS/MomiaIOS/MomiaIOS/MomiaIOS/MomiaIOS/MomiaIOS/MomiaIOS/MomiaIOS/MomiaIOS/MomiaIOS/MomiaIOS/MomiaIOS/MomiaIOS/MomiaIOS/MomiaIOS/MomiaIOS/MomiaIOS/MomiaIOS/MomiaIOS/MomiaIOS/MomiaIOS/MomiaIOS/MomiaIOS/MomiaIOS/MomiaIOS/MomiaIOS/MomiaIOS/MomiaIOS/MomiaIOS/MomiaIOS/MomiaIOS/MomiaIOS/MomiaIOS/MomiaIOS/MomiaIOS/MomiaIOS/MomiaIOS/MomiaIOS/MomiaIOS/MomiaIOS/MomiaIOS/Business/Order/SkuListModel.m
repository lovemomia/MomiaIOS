//
//  SkuListModel.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/15.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "SkuListModel.h"

@implementation Sku
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"ids"
                                                       }];
}
@end

@implementation Contact
@end

@implementation SkuListData
@end

@implementation SkuListModel
@end
