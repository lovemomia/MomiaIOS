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
    if (data.text) {
        [self.textLabel setText:data.text];
        self.textLabel.hidden = NO;
        
    } else {
        self.textLabel.hidden = YES;
//        self.photoImageView.top = 0;
    }
    
    if (data.image) {
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:data.image]];
        self.photoImageView.hidden = NO;
        
    } else {
        self.photoImageView.hidden = YES;
    }
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

+ (CGFloat)heightWithData:(ArticleDetailContentItem *)data {
    CGFloat height;
    if (data.text) {
        CGRect textFrame = [UILabel heightForMutableString:data.text withWidth:(SCREEN_WIDTH - 16) andFontSize:16.0];
        height += textFrame.size.height;
        
    }
    
    if (data.image) {
        height += 170;
        
    }
    return height + 25;
}

@end
