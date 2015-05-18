//
//  ArticleDetailContentCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/7.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleDetailModel.h"

@interface ArticleDetailContentCell : UITableViewCell

@property (strong, nonatomic) UILabel *contentLabel;

@property (strong, nonatomic) UIImageView *photoImageView;

+ (instancetype)cellWithTableView:(UITableView *)tableView withData:(ArticleDetailContentItem *)data;

+ (CGFloat)heightWithData:(ArticleDetailContentItem *)data;

- (void)setData:(ArticleDetailContentItem *)data;

@end
