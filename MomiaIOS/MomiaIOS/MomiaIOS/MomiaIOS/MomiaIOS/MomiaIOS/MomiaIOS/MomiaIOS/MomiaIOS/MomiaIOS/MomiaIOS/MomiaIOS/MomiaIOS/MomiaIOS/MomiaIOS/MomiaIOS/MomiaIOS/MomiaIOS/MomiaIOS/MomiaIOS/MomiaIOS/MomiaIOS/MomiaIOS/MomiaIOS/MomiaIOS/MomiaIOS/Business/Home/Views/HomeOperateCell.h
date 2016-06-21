//
//  HomeOperateCell.h
//  MomiaIOS
//
//  首页运营cell
//
//  Created by Deng Jun on 15/10/8.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeOperateCell : UITableViewCell

- (instancetype)initWithTableView:(UITableView *) tableView forModel:(id)model reuseIdentifier:(NSString *)identifier;

+ (CGFloat)heightWithTableView:(UITableView *) tableView forModel:(id)model;

@end
