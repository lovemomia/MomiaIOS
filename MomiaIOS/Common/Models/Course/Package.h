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

@interface Package : JSONModel

@property (nonatomic, strong) NSNumber *ids;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) CGFloat originalPrice;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSNumber *joined;
@property (nonatomic, strong) NSArray *imgs;

@property (nonatomic, strong) NSString *intro;
@property (nonatomic, strong) NSArray<Notice> *notice;

@end
