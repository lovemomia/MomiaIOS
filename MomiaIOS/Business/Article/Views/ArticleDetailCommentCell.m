//
//  ArticleDetailCommentCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/11.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ArticleDetailCommentCell.h"

@implementation ArticleDetailCommentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(ArticleCommentItem *)data {
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:data.authorIcon]];
    [self.nameLable setText:data.author];
    [self.dateLable setText:data.time];
    [self.commentLable setText:data.content];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *commentIdentifier = @"CellComment";
    ArticleDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentIdentifier];
    if (cell == nil) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"ArticleDetailCells" owner:self options:nil];
        cell = [arr objectAtIndex:3];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

+ (CGFloat)heightWithData:(ArticleCommentItem *)data {
    CGFloat height;
    
    if (data.content) {
        CGRect textFrame = [UILabel heightForMutableString:data.content withWidth:(SCREEN_WIDTH - 16) andFontSize:15.0];
        height += textFrame.size.height;
        
    }
    
    return height + 44 +24;//44为固定图片高度
}



@end
