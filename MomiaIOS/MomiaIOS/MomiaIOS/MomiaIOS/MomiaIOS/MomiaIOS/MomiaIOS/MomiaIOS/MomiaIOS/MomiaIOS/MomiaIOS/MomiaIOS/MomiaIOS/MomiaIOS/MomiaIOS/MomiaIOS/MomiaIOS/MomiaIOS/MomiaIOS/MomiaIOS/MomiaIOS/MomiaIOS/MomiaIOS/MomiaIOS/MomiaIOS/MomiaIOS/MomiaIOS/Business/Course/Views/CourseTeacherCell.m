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
#import "TTTAttributedLabel.h"


@implementation CourseTeacherCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setData:(CourseTeacher *)data {
    for (UIView * view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    UILabel *titleLabel;
    if ([data.isFirst boolValue]) {
        UIView *flagView = [UIView new];
        flagView.backgroundColor = MO_APP_ThemeColor;
        [self.contentView addSubview:flagView];
        [flagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@20);
            make.width.equalTo(@3);
            make.left.equalTo(self.contentView).with.offset(10);
            make.top.equalTo(self.contentView).with.offset(10);
        }];
        
        titleLabel = [UILabel new];
        titleLabel.numberOfLines = 1;
        titleLabel.textColor = UIColorFromRGB(0x333333);
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.text = @"专业讲师";
        [self.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@20);
            make.left.equalTo(flagView).with.offset(10);
            make.top.equalTo(self.contentView).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-10);
        }];
    }
    
    AvatarImageView *avatar = [AvatarImageView new];
    avatar.backgroundColor = UIColorFromRGB(0xcccccc);
    [avatar sd_setImageWithURL:[NSURL URLWithString:data.avatar]];
    [self.contentView addSubview:avatar];
    // 圆形
    avatar.layer.masksToBounds = YES;
    avatar.layer.cornerRadius = 20;
    avatar.layer.borderWidth = 1;
    avatar.layer.borderColor = [[UIColor colorWithRed:85 green:85 blue:85 alpha:1] CGColor];
    
    [avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.width.equalTo(@40);
        make.left.equalTo(self.contentView).with.offset(10);
        make.top.equalTo(titleLabel ? titleLabel.mas_bottom : self.contentView).with.offset(10);
//        make.bottom.equalTo(self.contentView).with.offset(-10);
//        make.right.equalTo(self.contentView).with.offset(-10);
    }];
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.numberOfLines = 1;
    nameLabel.textColor = UIColorFromRGB(0x333333);
    nameLabel.font = [UIFont systemFontOfSize:13];
    nameLabel.text = data.name;
    [self.contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.left.equalTo(avatar.mas_right).with.offset(10);
        make.top.equalTo(avatar.mas_top).with.offset(0);
        make.right.equalTo(self.contentView).with.offset(-10);
    }];
    
    UILabel *educationLabel = [UILabel new];
    educationLabel.numberOfLines = 1;
    educationLabel.textColor = UIColorFromRGB(0x999999);
    educationLabel.font = [UIFont systemFontOfSize:13];
    educationLabel.text = data.education;
    [self.contentView addSubview:educationLabel];
    [educationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.left.equalTo(avatar.mas_right).with.offset(10);
        make.top.equalTo(nameLabel.mas_bottom).with.offset(0);
        make.right.equalTo(self.contentView).with.offset(-10);
    }];
    
    TTTAttributedLabel *label = [TTTAttributedLabel new];
    label.numberOfLines = 0;
    label.textColor = UIColorFromRGB(0x666666);
    label.font = [UIFont systemFontOfSize:13];
    label.lineSpacing = 6;
    label.text = data.experience;
    [self.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(10);
        make.top.equalTo(avatar.mas_bottom).with.offset(10);
        make.bottom.equalTo(self.contentView).with.offset(-10);
        make.right.equalTo(self.contentView).with.offset(-10);
    }];
    
}

@end
