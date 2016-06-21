//
//  MOGroupStyleTableViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/27.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOGroupStyleTableViewController.h"

@implementation MOGroupStyleTableViewController

- (UITableViewStyle)tableViewStyle {
    return UITableViewStyleGrouped;
}

- (UITableViewCellSeparatorStyle)tableViewCellSeparatorStyle {
    return UITableViewCellSeparatorStyleSingleLine;
}

#pragma mark tableView delegate, dataSource
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if ([self tableViewStyle] == UITableViewStyleGrouped) {
//        UIView *content = [[UIView alloc]init];
//        UIView *view = [[UIView alloc]init];
//        view.contentMode = UIViewContentModeScaleToFill;
//        view.height = 2;
//        view.width = SCREEN_WIDTH;
//        if (section == 0) {
//            view.top = 29;
//        } else {
//            view.top = 9;
//        }
//        view.backgroundColor = MO_APP_VCBackgroundColor;
//        [content addSubview:view];
//        return content;
//    }
//    return nil;
//}
//
//

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    if ([self tableViewStyle] == UITableViewStyleGrouped) {
//        UIView *content = [[UIView alloc]init];
//        UIImageView *view = [[UIImageView alloc]init];
//        view.contentMode = UIViewContentModeScaleToFill;
//        view.height = 5;
//        view.width = SCREEN_WIDTH;
//        view.top = 0;
//        view.image = [UIImage imageNamed:@"bg_card"];
//        [content addSubview:view];
//        return content;
//    }
//    return nil;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    if ([self tableViewStyle] == UITableViewStyleGrouped) {
//        return 10;
//    }
//    return 0;
//}

#pragma mark -
#pragma mark Override inset setting

- (UIEdgeInsets)tableViewOriginalContentInset {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (UIEdgeInsets)separatorInsetForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(0,10,0,0);
}

@end
