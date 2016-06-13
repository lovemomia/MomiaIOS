//
//  SugTagsModel.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/21.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "SugTagsModel.h"

@implementation Tag

#pragma mark -
#pragma mark keyMapper

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"pairID"
                                                       }];
}

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    if([propertyName isEqualToString:@"isSelected"])
        return YES;
    
    return NO;
}

@end

@implementation SugTagsData
@end

@implementation SugTagsModel

@end
