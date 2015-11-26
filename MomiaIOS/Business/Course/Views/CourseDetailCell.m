//
//  CourseDetailCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/11/23.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "CourseDetailCell.h"
#import "Course.h"
#import "TTTAttributedLabel.h"

#define LineSpacing 6
#define titleFontSize 13.0f
#define contentFontSize 13.0f
#define ImgScale 0.75

@implementation CourseDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(Course *)data {
    for (UIView * view in self.contentView.subviews) {
        if([view isKindOfClass:[UIImageView class]] || [view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    
    // goal
    TTTAttributedLabel *label = [[TTTAttributedLabel alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(12);
        make.left.equalTo(self.contentView).with.offset(10);
        make.right.equalTo(self.contentView).with.offset(-10);
        make.bottom.lessThanOrEqualTo(self.contentView).with.offset(-12);
    }];
    label.numberOfLines = 0;
    label.textColor = UIColorFromRGB(0x333333);
    label.font = [UIFont systemFontOfSize:contentFontSize];
    label.lineSpacing = LineSpacing;
    label.text = data.goal;
    
    // detail
    UIView *lastView = label;
    for (int i = 0; i < data.detail.count; i++) {
        CourseDetail *detail = data.detail[i];
        
        // title index
        UILabel *index = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
        index.layer.masksToBounds = YES;
        index.layer.cornerRadius = 7.5;
        [self.contentView addSubview:index];
        [index mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastView.mas_bottom).with.offset(15);
            make.left.equalTo(self.contentView).with.offset(10);
            make.width.equalTo(@15);
            make.bottom.lessThanOrEqualTo(self.contentView).with.offset(-12);
        }];
        index.textColor = [UIColor whiteColor];
        index.backgroundColor = MO_APP_ThemeColor;
        index.font = [UIFont boldSystemFontOfSize:titleFontSize];
        index.text = [NSString stringWithFormat:@"%d", (i+1)];
        index.textAlignment = NSTextAlignmentCenter;
        
        //title
        TTTAttributedLabel *title = [[TTTAttributedLabel alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastView.mas_bottom).with.offset(15);
            make.left.equalTo(index.mas_right).with.offset(5);
            make.right.equalTo(self.contentView).with.offset(-10);
            make.bottom.lessThanOrEqualTo(self.contentView).with.offset(-12);
        }];
        title.numberOfLines = 0;
        title.textColor = UIColorFromRGB(0x333333);
        title.font = [UIFont boldSystemFontOfSize:titleFontSize];
        title.lineSpacing = LineSpacing;
        title.text = detail.title;
        lastView = title;
        
        for (int i = 0; i < detail.content.count; i++) {
            CourseDetailContent *content = detail.content[i];
            if (content.img) {
                UIImageView *image = [[UIImageView alloc]init];
                [self.contentView addSubview:image];
                [image mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lastView.mas_bottom).with.offset(12);
                    make.left.equalTo(self.contentView).with.offset(10);
                    make.right.equalTo(self.contentView).with.offset(-10);
                    make.height.equalTo(@((SCREEN_WIDTH - 20) * ImgScale));
                    make.bottom.lessThanOrEqualTo(self.contentView).with.offset(-12);
                }];
                [image sd_setImageWithURL:[NSURL URLWithString:content.img]];
                lastView = image;
            }
            
            if (content.text) {
                TTTAttributedLabel *text = [[TTTAttributedLabel alloc]initWithFrame:CGRectZero];
                [self.contentView addSubview:text];
                [text mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lastView.mas_bottom).with.offset(12);
                    make.left.equalTo(self.contentView).with.offset(10);
                    make.right.equalTo(self.contentView).with.offset(-10);
                    make.bottom.lessThanOrEqualTo(self.contentView).with.offset(-12);
                }];
                text.numberOfLines = 0;
                text.textColor = UIColorFromRGB(0x333333);
                text.font = [UIFont systemFontOfSize:contentFontSize];
                text.lineSpacing = LineSpacing;
                text.text = content.text;
                lastView = text;
            }
        }
    }
}

@end
