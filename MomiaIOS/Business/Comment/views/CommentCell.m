//
//  CommentCell.m
//  MomiaIOS
//
//  Created by Owen on 15/5/25.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

- (void)awakeFromNib {
    // Initialization code
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = self.iconImageView.bounds.size.width * 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setData:(CommentItem *)data {
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:data.authorIcon]];
    [self.nameLable setText:data.author];
    [self.dateLable setText:data.time];
    [self.lineView setBackgroundColor:MO_APP_VCBackgroundColor];
    [self.commentLable setText:data.content];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *commentIdentifier = @"CellComment";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentIdentifier];
    if (cell == nil) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"ArticleDetailCells" owner:self options:nil];
        cell = [arr objectAtIndex:2];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

+ (CGFloat)heightWithData:(CommentItem *)data {
    CGFloat height = 0;
    
    if (data.content) {
        CGRect textFrame = [UILabel heightForMutableString:data.content withWidth:(SCREEN_WIDTH - 79)  lineSpace:0 andFontSize:15.0];
        height += textFrame.size.height;
        
    }
    
    return height + 49;//44为固定图片高度
}



@end