//
//  ArticleDetailAuthorCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/11.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ArticleDetailAuthorCell.h"

@implementation ArticleDetailAuthorCell

- (void)awakeFromNib {
    // Initialization code
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = self.iconImageView.bounds.size.width * 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(ArticleDetailData *)data {
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:data.authorIcon]];
    [self.nameLable setText:data.author];
    [self.accountLable setText:data.authorAccount];
    [self.descLable setText:data.authorDesc];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CellAuthor";
    ArticleDetailAuthorCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"ArticleDetailCells" owner:self options:nil];
        cell = [arr objectAtIndex:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

+ (CGFloat)height {
    return 105;
}

@end
