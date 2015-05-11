//
//  ArticleDetailContentCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/7.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ArticleDetailContentCell.h"
#import "Constants.h"

@interface ArticleDetailContentCell()

@property (nonatomic, assign)BOOL hasGetWebHeight;

@end

@implementation ArticleDetailContentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(ArticleDetailContentItem *)data {
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:data.image]];
    [self.textLabel setText:data.text];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CellContent";
    ArticleDetailContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"ArticleDetailCells" owner:self options:nil];
        cell = [arr objectAtIndex:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

+ (CGFloat)height {
    return 254;
}

@end
