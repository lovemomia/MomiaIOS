//
//  PlaymateContentCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/6/26.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feed.h"

@interface FeedContentCell : UITableViewCell

- (instancetype)initWithTableView:(UITableView *) tableView contentModel:(Feed *)model;

+ (CGFloat)heightWithTableView:(UITableView *) tableView contentModel:(Feed *)model;

@end
