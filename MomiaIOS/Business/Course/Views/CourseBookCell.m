//
//  CourseBookCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/14.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "CourseBookCell.h"
#import "Course.h"

static const int kImageWidth = 90;
static const int kImageHeight = 68;

@implementation CourseBookCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(CourseBook *)data {
    for (UIView * view in self.contentView.subviews) {
        if([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    for (int i = 0; i < data.imgs.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((i + 1) * 10 + i * kImageWidth, 10, kImageWidth, kImageHeight)];
        imageView.backgroundColor = UIColorFromRGB(0xcccccc);
        [imageView sd_setImageWithURL:[NSURL URLWithString:data.imgs[i]]];
        [self.contentView addSubview:imageView];
    }
}

+ (CGFloat)heightWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath data:(id)data {
    return kImageHeight + 20;
}

@end
