//
//  CourseBookCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/14.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "CourseBookCell.h"
#import "Course.h"

static const int kImageWidth = 93;
static const int kImageHeight = 93;

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
        if([view isKindOfClass:[UIScrollView class]]) {
            [view removeFromSuperview];
        }
    }
    
    CGFloat width = (kImageWidth + 10) * data.imgs.count + 10;
    CGFloat height = kImageHeight + 20;
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    scrollView.scrollEnabled = YES;
    scrollView.contentSize = CGSizeMake(width, height);
    [self.contentView addSubview:scrollView];
    
    for (int i = 0; i < data.imgs.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((i + 1) * 10 + i * kImageWidth, 10, kImageWidth, kImageHeight)];
        imageView.backgroundColor = UIColorFromRGB(0xcccccc);
        [imageView sd_setImageWithURL:[NSURL URLWithString:data.imgs[i]]];
        [scrollView addSubview:imageView];
        imageView.layer.cornerRadius = 3.0f;
    }
}

+ (CGFloat)heightWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath data:(id)data {
    return kImageHeight + 20;
}

@end
