//
//  CourseTeacherCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/14.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "CourseTeacherCell.h"
#import "Course.h"
#import "AvatarImageView.h"

static const int kImageWidth = 40;
static const int kImageHeight = 40;

@implementation CourseTeacherCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setData:(NSArray *)data {
    for (UIView * view in self.contentView.subviews) {
        if([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    for (int i = 0; i < data.count; i++) {
        CourseTeacher *teacher = data[i];
        AvatarImageView *imageView = [[AvatarImageView alloc]initWithFrame:CGRectMake((i + 1) * 10 + i * kImageWidth, 10, kImageWidth, kImageHeight)];
        imageView.backgroundColor = UIColorFromRGB(0xcccccc);
        [imageView sd_setImageWithURL:[NSURL URLWithString:teacher.avatar]];
        [self.contentView addSubview:imageView];
    }
}

+ (CGFloat)heightWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath data:(id)data {
    return kImageHeight + 20;
}

@end
