//
//  HomeTopicCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/4/23.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "HomeTopicCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define TitleFont [UIFont systemFontOfSize:21]
#define TimeFont [UIFont systemFontOfSize:15]

@implementation HomeTopicCell
@synthesize coverImage;
@synthesize titleLable;
@synthesize timeLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CellArticle";
    HomeTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
//        cell = [[HomeTopicCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"HomeTopicCell" owner:self options:nil];
        cell = [arr objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

+ (CGFloat)height {
    return 267;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        int totalHeight;
        int padding = 10;
        // cover image
        int coverHeight = 200;
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, coverHeight)];
        image.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:image];
        self.coverImage = image;
        totalHeight += coverHeight;
        
        // title
        int titleHeight = 50;
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(padding, coverHeight, SCREEN_WIDTH, titleHeight)];
        title.text = @"麻麻们必须注意";
        [self.contentView addSubview:title];
        self.titleLable = title;
        totalHeight += titleHeight;
        
        // time
        int timeWidth = 45;
        UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - timeWidth - padding, coverHeight, timeWidth, titleHeight)];
        time.text = @"03/23";
        time.textColor = [UIColor lightGrayColor];
        time.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:time];
        self.timeLabel = time;
        
        // set cell height
        CGRect frame = self.frame;
        frame.size.height = totalHeight;
        self.frame = frame;
        self.height = totalHeight;
    }
    return self;
}

- (void)setData:(HomeTopic *)data {
    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:data.photo]];
    [self.titleLable setText:data.title];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
