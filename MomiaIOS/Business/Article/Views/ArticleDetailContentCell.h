//
//  ArticleDetailContentCell.h
//  MomiaIOS
//
//  Created by Owen on 15/5/18.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleDetailModel.h"

@interface ArticleDetailContentCell : UITableViewCell

@property (strong, nonatomic) UILabel *contentLabel;

@property (strong, nonatomic) UIImageView *photoImageView;

+ (instancetype)cellWithTableView:(UITableView *)tableView withData:(ArticleDetailContentItem *)data;

+ (CGFloat)heightWithData:(ArticleDetailContentItem *)data;

@end

