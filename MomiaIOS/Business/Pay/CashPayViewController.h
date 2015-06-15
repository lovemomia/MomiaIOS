//
//  CashPayViewController.h
//  MomiaIOS
//
//  Created by Owen on 15/6/10.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOViewController.h"
#import "WechatPayDelegate.h"

@interface CashPayViewController : MOViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) id<WechatPayDelegate> delegate;

- (IBAction)onPayClicked:(id)sender;


@end
