//
//  PlaymateViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/6/23.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "PlaymateViewController.h"
#import "PlaymateUserCell.h"
#import "PlaymateContentCell.h"
#import "PlaymateOperateCell.h"
#import "PlaymatePeopleCell.h"

@implementation PlaymateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"玩伴";
}

- (UITableViewStyle)tableViewStyle {
    return UITableViewStyleGrouped;
}

- (UITableViewCellSeparatorStyle)tableViewCellSeparatorStyle {
    return UITableViewCellSeparatorStyleSingleLine;
}

- (UIEdgeInsets)separatorInset {
    return UIEdgeInsetsMake(0,57,0,0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [PlaymateUserCell cellWithTableView:tableView data:nil];
    } else if (indexPath.row == 1) {
        cell = [PlaymateContentCell cellWithTableView:tableView data:nil];
    } else {
        cell = [PlaymateOperateCell cellWithTableView:tableView data:nil];
    }
    return cell;
}

@end
