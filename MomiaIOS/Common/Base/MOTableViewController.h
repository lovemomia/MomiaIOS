//
//  MOTableViewController.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/7.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOViewController.h"

@interface MOTableViewController : MOViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView *tableView;

- (UITableViewStyle)tableViewStyle;

/**
 *  TableView初始ContentInset
 *
 *  @return TableView初始ContentInset
 */
- (UIEdgeInsets)tableViewOriginalContentInset;

@end
