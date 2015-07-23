//
//  PlaymateViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/6/23.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "PlaymateViewController.h"

#import "PlaymateUserHeadCell.h"
#import "PlaymateUgcCell.h"
#import "PlaymateContentCell.h"

static NSString *identifierPlaymateUserHeadCell = @"PlaymateUserHeadCell";
static NSString *identifierPlaymateUgcCell = @"PlaymateUgcCell";

@interface PlaymateViewController()
@property(nonatomic,strong) NSMutableDictionary * contentCellHeightCacheDic;
@end

@implementation PlaymateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"玩伴";
    
    [PlaymateUserHeadCell registerCellWithTableView:self.tableView withIdentifier:identifierPlaymateUserHeadCell];
    [PlaymateUgcCell registerCellWithTableView:self.tableView withIdentifier:identifierPlaymateUgcCell];
}

- (UITableViewStyle)tableViewStyle {
    return UITableViewStyleGrouped;
}

- (UITableViewCellSeparatorStyle)tableViewCellSeparatorStyle {
    return UITableViewCellSeparatorStyleSingleLine;
}

- (UIEdgeInsets)separatorInset {
    return UIEdgeInsetsMake(0,65,0,0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [PlaymateUserHeadCell heightWithTableView:tableView withIdentifier:identifierPlaymateUserHeadCell forIndexPath:indexPath data:@"x"];
    } else if (indexPath.row == 2) {
        return [PlaymateUgcCell heightWithTableView:tableView withIdentifier:identifierPlaymateUgcCell forIndexPath:indexPath data:@"x"];
    } else {
        return [PlaymateContentCell heightWithTableView:tableView contentModel:nil];
    }
    return 155;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        PlaymateUserHeadCell * userHead = [PlaymateUserHeadCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierPlaymateUserHeadCell];
        [userHead setData:@""];
        cell = userHead;
        
    } else if (indexPath.row == 1) {
        cell = [[PlaymateContentCell alloc]initWithTableView:tableView contentModel:nil];
    } else {
        PlaymateUgcCell * ugc = [PlaymateUgcCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierPlaymateUgcCell];
        cell = ugc;
    }
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

@end
