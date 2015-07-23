//
//  PlaymateContentCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/6/26.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlaymateFeed;

@interface PlaymateContentCell : UITableViewCell

- (instancetype)initWithTableView:(UITableView *) tableView contentModel:(PlaymateFeed *)model;

+ (CGFloat)heightWithTableView:(UITableView *) tableView contentModel:(PlaymateFeed *)model;

@end
