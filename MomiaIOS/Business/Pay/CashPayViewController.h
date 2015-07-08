//
//  CashPayViewController.h
//  MomiaIOS
//
//  Created by Owen on 15/6/10.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOGroupStyleTableViewController.h"
#import "WechatPayDelegate.h"

@interface CashPayViewController : MOGroupStyleTableViewController

@property (nonatomic, assign) id<WechatPayDelegate> delegate;

@end
