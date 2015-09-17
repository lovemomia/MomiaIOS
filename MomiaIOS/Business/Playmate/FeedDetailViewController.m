//
//  PlaymateDetailViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/27.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "FeedDetailViewController.h"
#import "FeedTitleCell.h"
#import "MyFavCell.h"
#import "FeedUserHeadCell.h"
#import "FeedContentCell.h"
#import "FeedZanCell.h"
#import "FeedMoreCell.h"
#import "FeedCommentCell.h"

static NSString *identifierPlaymateUserHeadCell = @"PlaymateUserHeadCell";
static NSString *identifierFeedZanCell = @"FeedZanCell";
static NSString * identifierMyFavCell = @"MyFavCell";
static NSString *identifierFeedTitleCell = @"FeedTitleCell";
static NSString *identifierFeedMoreCell = @"FeedMoreCell";
static NSString *identifierFeedCommentCell = @"FeedCommentCell";

@interface FeedDetailViewController ()

@end

@implementation FeedDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"详情";
    
    [FeedUserHeadCell registerCellWithTableView:self.tableView withIdentifier:identifierPlaymateUserHeadCell];
    [FeedZanCell registerCellWithTableView:self.tableView withIdentifier:identifierFeedZanCell];
    [FeedTitleCell registerCellWithTableView:self.tableView withIdentifier:identifierFeedTitleCell];
    [MyFavCell registerCellWithTableView:self.tableView withIdentifier:identifierMyFavCell];
    [FeedMoreCell registerCellWithTableView:self.tableView withIdentifier:identifierFeedMoreCell];
    [FeedCommentCell registerCellWithTableView:self.tableView withIdentifier:identifierFeedCommentCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewStyle)tableViewStyle {
    return UITableViewStyleGrouped;
}

- (UITableViewCellSeparatorStyle)tableViewCellSeparatorStyle {
    return UITableViewCellSeparatorStyleSingleLine;
}

- (UIEdgeInsets)separatorInsetForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return UIEdgeInsetsMake(0,65,0,0);
    }
    return UIEdgeInsetsMake(0,10,0,0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 2;
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return [FeedUserHeadCell heightWithTableView:tableView withIdentifier:identifierPlaymateUserHeadCell forIndexPath:indexPath data:nil];
        } else if (indexPath.row == 1) {
            return [FeedContentCell heightWithTableView:tableView contentModel:nil];
        } else {
            return [FeedZanCell heightWithTableView:tableView withIdentifier:identifierFeedZanCell forIndexPath:indexPath data:nil];
        }
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return [FeedTitleCell heightWithTableView:tableView withIdentifier:identifierFeedTitleCell forIndexPath:indexPath data:@"相关活动"];
        } else {
//            return [MyFavCell heightWithTableView:tableView withIdentifier:identifierMyFavCell forIndexPath:indexPath data:nil];
            return 87;
        }
        
    } else {
        if (indexPath.row == 0) {
            return [FeedTitleCell heightWithTableView:tableView withIdentifier:identifierFeedTitleCell forIndexPath:indexPath data:@"最新评论"];
        } else if (indexPath.row == 4) {
            return [FeedMoreCell heightWithTableView:tableView withIdentifier:identifierFeedMoreCell forIndexPath:indexPath data:@"查看更多评论"];
        } else {
            return [FeedCommentCell heightWithTableView:tableView withIdentifier:identifierFeedCommentCell forIndexPath:indexPath data:nil];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView] - 1) {
        return 60;
    }
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            FeedUserHeadCell * userHead = [FeedUserHeadCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierPlaymateUserHeadCell];
            [userHead setData:@""];
            cell = userHead;
            
        } else if (indexPath.row == 1) {
            cell = [[FeedContentCell alloc]initWithTableView:tableView contentModel:nil];
            
        } else {
            cell = [FeedZanCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierFeedZanCell];
        }
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            FeedTitleCell *titleCell = [FeedTitleCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierFeedTitleCell];
            titleCell.data = @"相关活动";
            cell = titleCell;
            
        } else {
            cell = [MyFavCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierMyFavCell];
        }
        
    } else {
        if (indexPath.row == 0) {
            FeedTitleCell *titleCell = [FeedTitleCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierFeedTitleCell];
            titleCell.data = @"最新评论";
            cell = titleCell;
            
        } else if (indexPath.row == 4) {
            cell = [FeedMoreCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierFeedMoreCell];
            
        } else {
            FeedCommentCell *commentCell = [FeedCommentCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierFeedCommentCell];
            commentCell.data = nil;
            cell = commentCell;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
