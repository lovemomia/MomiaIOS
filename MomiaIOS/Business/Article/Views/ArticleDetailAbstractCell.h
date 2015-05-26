//
//  ArticleDetailAbstractCell.h
//  MomiaIOS
//
//  Created by Owen on 15/5/25.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ArticleDetailData;

@interface ArticleDetailAbstractCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *abstractLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)heightWithData:(ArticleDetailData *)data;

- (void)setData:(ArticleDetailData *)data;

@end
