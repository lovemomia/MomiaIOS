//
//  ArticleTopicHeaderCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/8.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ArticleTopicHeaderCell.h"
#import "Constants.h"
#import "UILabel+ContentSize.h"

@implementation ArticleTopicHeaderCell
@synthesize coverIv;
@synthesize titleTv;
@synthesize introTv;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(ArticleTopicData *)data {
    [self.coverIv sd_setImageWithURL:[NSURL URLWithString:data.topicPhoto]];
    [self.titleTv setText:data.topicTitle];
    [self.introTv setText:data.abstracts];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CellHeader";
    ArticleTopicHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"ArticleTopicCells" owner:self options:nil];
        cell = [arr objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

+ (CGFloat)height {
    return 300;
}

+ (CGFloat)coverHeight {
    return 217;
}

@end
