//
//  Package.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/13.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "JSONModel.h"

@protocol Notice <NSObject>
@end

@interface Subject : JSONModel

@property (nonatomic, strong) NSNumber *ids;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) CGFloat originalPrice;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSNumber *joined;
@property (nonatomic, strong) NSArray<Optional> *imgs;

@property (nonatomic, strong) NSString<Optional> *tags; //标签
@property (nonatomic, strong) NSString<Optional> *scheduler;
@property (nonatomic, strong) NSString<Optional> *region;
@property (nonatomic, strong) NSString<Optional> *cover;

@property (nonatomic, strong) NSString<Optional> *intro;
@property (nonatomic, strong) NSArray<Notice, Optional> *notice;

@property (nonatomic, strong) NSNumber<Optional> *status;

@end
