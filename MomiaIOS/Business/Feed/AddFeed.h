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
@property (nonatomic, strong) NSNumber *productId;
@property (nonatomic, strong) NSNumber *topicId;
@property (nonatomic, strong) NSString *topic;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) CGFloat lng;
@property (nonatomic, assign) CGFloat lat;

@end

@protocol UploadImageData <NSObject>
@end

@interface AddFeed : JSONModel
@property (nonatomic, strong) BaseFeed *baseFeed;
@property (nonatomic, strong) NSArray<UploadImageData> *imgs;
@end
