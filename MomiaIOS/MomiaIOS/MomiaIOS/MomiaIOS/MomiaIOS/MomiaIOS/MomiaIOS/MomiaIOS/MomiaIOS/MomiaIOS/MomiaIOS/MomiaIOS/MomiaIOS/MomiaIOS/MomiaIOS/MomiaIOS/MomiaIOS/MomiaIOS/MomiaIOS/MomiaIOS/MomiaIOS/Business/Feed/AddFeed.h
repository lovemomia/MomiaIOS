//
//  AddFeed.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/9/23.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "JSONModel.h"

@interface AddFeed : JSONModel

@property (nonatomic, strong) NSNumber *type; // 1 参加了  2 评论了
@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSNumber *courseId;
@property (nonatomic, strong) NSString *courseTitle;

// Optional
@property (nonatomic, strong) NSNumber *tagId;
@property (nonatomic, strong) NSString *tagName;
@property (nonatomic, assign) CGFloat lng;
@property (nonatomic, assign) CGFloat lat;
@property (nonatomic, strong) NSArray *imgs;

@end
