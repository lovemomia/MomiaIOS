//
//  HomeGridCell.h
//  MomiaIOS
//
//  首页九宫格菜单
//
//  Created by Deng Jun on 15/10/8.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeGridCell : UITableViewCell

- (instancetype)initWithTableView:(UITableView *) tableView forModel:(id)model reuseIdentifier:(NSString *)identifier;

+ (CGFloat)heightWithTableView:(UITableView *) tableView forModel:(id)model;


@end
