//
//  OrderPersonViewController.h
//  MomiaIOS
//
//  Created by Owen on 15/6/10.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOViewController.h"

typedef void(^OnFinishClick)();

struct PersonStyle {
    NSUInteger adult;
    NSUInteger child;
};
typedef struct PersonStyle PersonStyle;

@interface OrderPersonViewController : MOViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSString * utoken;
@property (nonatomic, assign) PersonStyle personStyle;
@property (nonatomic, strong) OnFinishClick onFinishClick;
@property (nonatomic, strong) NSMutableDictionary * selectedDictionary;

@end
