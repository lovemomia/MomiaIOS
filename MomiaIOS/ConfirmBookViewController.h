//
//  ConfirmBookViewController.h
//  MomiaIOS
//
//  Created by mosl on 16/4/5.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "MOGroupStyleTableViewController.h"

@interface ConfirmBookViewController : MOGroupStyleTableViewController

@property(nonatomic,assign) NSInteger choosedChildItem;
@property (nonatomic,strong) NSNumber *selectSkuIds;
@property (nonatomic, strong) NSString *pid;

@end
