//
//  PlaymateDetailViewController.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/27.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOViewController.h"

@interface FeedDetailViewController : MOViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)onZanClicked:(id)sender;
- (IBAction)onCommentClicked:(id)sender;

@end
