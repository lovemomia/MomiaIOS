//
//  ArticleDetailHeaderCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/11.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleDetailModel.h"

@interface ArticleDetailHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)height;

+ (CGFloat)coverHeight;

- (void)setData:(ArticleDetailData *)data;

@end
