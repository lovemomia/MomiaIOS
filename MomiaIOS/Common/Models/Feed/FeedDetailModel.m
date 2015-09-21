//
//  FeedDetailModel.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/9/17.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "FeedDetailModel.h"

@implementation FeedComment
@end

@implementation FeedCommentList
@end

@implementation FeedStar
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"ids"
                                                       }];
}
@end

@implementation FeedStarList
@end

@implementation FeedDetailData
@end

@implementation FeedDetailModel
@end
