//
//  AddFeedContentCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/9/23.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddFeed.h"

@interface AddFeedContentCell : UITableViewCell

- (instancetype)initWithTableView:(UITableView *) tableView content:(NSString *)content andImages:(NSArray *)images;

+ (CGFloat)heightWithTableView:(UITableView *) tableView content:(AddFeed *)model;

@end
