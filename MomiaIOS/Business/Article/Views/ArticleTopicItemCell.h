//
//  ArticleTopicItemCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/11.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleTopicModel.h"

@interface ArticleTopicItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *sortImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *abstractsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)height;

- (void)setData:(ArticleTopicItem *)data;

@end
