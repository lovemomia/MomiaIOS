//
//  AddFeed.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/9/23.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "JSONModel.h"
#import "UploadImageModel.h"

@interface BaseFeed : JSONModel

//@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSNumber *type; // 1 参加了  2 评论了
@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSNumber *topicId;
@property (nonatomic, assign) CGFloat lng;
@property (nonatomic, assign) CGFloat lat;

@end

@protocol UploadImageData <NSObject>
@end

@interface AddFeed : JSONModel
@property (nonatomic, strong) BaseFeed *baseFeed;
@property (nonatomic, strong) NSArray<UploadImageData> *imgs;
@end
