//
//  ArticleDetailAbstractCell.m
//  MomiaIOS
//
//  Created by Owen on 15/5/25.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ArticleDetailAbstractCell.h"
#import "ArticleDetailModel.h"

#define contentFont [UIFont boldSystemFontOfSize:15.0f]

@implementation ArticleDetailAbstractCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setData:(ArticleDetailData *)data {
    [self.abstractLabel setText:data.abstracts];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CellAbstract";
    ArticleDetailAbstractCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"ArticleDetailCells" owner:self options:nil];
        cell = [arr objectAtIndex:3];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

+ (CGFloat)heightWithData:(ArticleDetailData *)data {

    CGFloat height = 0;
    
    if(data.abstracts) {
        CGRect textFrame = [UILabel heightForMutableString:data.abstracts withWidth:SCREEN_WIDTH - 16 andFont:contentFont];
        height += textFrame.size.height;
    }
    
    height+= 17;
    
    return height;
}


@end
