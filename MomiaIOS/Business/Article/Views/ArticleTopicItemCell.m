//
//  ArticleTopicItemCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/11.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ArticleTopicItemCell.h"

@implementation ArticleTopicItemCell

- (void)setData:(ArticleTopicItem *)data {
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:data.photo]];
    [self.titleLabel setText:data.title];
    [self.abstractsLabel setText:data.abstracts];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CellArticle";
    ArticleTopicItemCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"ArticleTopicCells" owner:self options:nil];
        cell = [arr objectAtIndex:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

+ (CGFloat)height {
    return 344;
}

@end
