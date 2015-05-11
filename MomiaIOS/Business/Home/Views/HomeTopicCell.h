//
//  HomeTopicCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/4/23.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

@interface HomeTopicCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (nonatomic, weak) IBOutlet UILabel *titleLable;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)height;

- (void)setData:(HomeTopic *)data;

@end
