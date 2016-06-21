//
//  MyStatusViewController.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/26.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableViewController.h"

typedef void (^BlockOperateSuccess)();

@interface MyStatusViewController : MOTableViewController

@property (nonatomic, strong) BlockOperateSuccess operateSuccessBlock;

@end
