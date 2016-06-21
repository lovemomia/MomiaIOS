//
//  FeedComment.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/9/22.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"

@interface FeedComment : JSONModel

@property (nonatomic, strong) NSNumber<Optional> *ids;
@property (nonatomic, strong) NSString *addTime;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *nickName;

@end
