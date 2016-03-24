//
//  CourseDiscCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/10.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "CourseDiscCell.h"
#import "TTTAttributedLabel.h"
#import "Subject.h"

@implementation CourseDiscCell

- (void)awakeFromNib {
    // Initialization code
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSString *)data {
    for (UIView * view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    UIView *flagView = [UIView new];
    flagView.backgroundColor = MO_APP_ThemeColor;
    [self.contentView addSubview:flagView];
    [flagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.width.equalTo(@3);
        make.left.equalTo(self.contentView).with.offset(10);
        make.top.equalTo(self.contentView).with.offset(10);
    }];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.numberOfLines = 1;
    titleLabel.textColor = UIColorFromRGB(0x333333);
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"上课注意事项";
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.left.equalTo(flagView).with.offset(10);
        make.top.equalTo(self.contentView).with.offset(10);
        make.right.equalTo(self.contentView).with.offset(-10);
    }];
    
    TTTAttributedLabel *label = [TTTAttributedLabel new];
    label.numberOfLines = 0;
    label.textColor = UIColorFromRGB(0x666666);
    label.font = [UIFont systemFontOfSize:13];
    label.lineSpacing = 6;
    label.text = data;
    [self.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(10);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(10);
        make.bottom.equalTo(self.contentView).with.offset(-10);
        make.right.equalTo(self.contentView).with.offset(-10);
    }];
}

@end
