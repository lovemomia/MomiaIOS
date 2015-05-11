//
//  ArticleDetailHeaderCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/11.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ArticleDetailHeaderCell.h"
#import "ArticleDetailModel.h"

@implementation ArticleDetailHeaderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(ArticleDetailData *)data {
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:data.coverPhoto]];
    [self.titleLabel setText:data.title];
    [self.authorLabel setText:data.abstracts];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CellHeader";
    ArticleDetailHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"ArticleDetailCells" owner:self options:nil];
        cell = [arr objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

+ (CGFloat)height {
    return 308;
}

+ (CGFloat)coverHeight {
    return 231;
}

@end
