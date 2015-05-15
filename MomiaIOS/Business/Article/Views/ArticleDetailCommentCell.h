//
//  ArticleDetailCommentCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/11.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleCommentModel.h"

@interface ArticleDetailCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *dateLable;
@property (weak, nonatomic) IBOutlet UILabel *commentLable;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)heightWithData:(ArticleCommentItem *)data;

- (void)setData:(ArticleCommentItem *)data;

@end
