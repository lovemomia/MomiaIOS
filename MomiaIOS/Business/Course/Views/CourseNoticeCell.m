//
//  CourseNoticeCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/14.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "CourseNoticeCell.h"
#import "TTTAttributedLabel.h"
#import "Subject.h"
#import "Notice.h"

@implementation CourseNoticeCell

- (void)awakeFromNib {
    // Initialization code
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSArray<Notice> *)notices {
    for (UIView * view in self.contentView.subviews) {
        if([view isKindOfClass:[TTTAttributedLabel class]]) {
            [view removeFromSuperview];
        }
    }
    
    UIView *lastView;
    for (int i = 0; i < notices.count; i++) {
        TTTAttributedLabel *title = [TTTAttributedLabel new];
        title.numberOfLines = 0;
        title.textColor = UIColorFromRGB(0x333333);
        title.font = [UIFont systemFontOfSize:14];
        title.lineSpacing = 6;
        title.text = ((Notice *)notices[i]).title;
        [self.contentView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-10);
            if (i == 0) {
                make.top.equalTo(self.contentView).with.offset(10);
            } else {
                make.top.equalTo(lastView.mas_bottom).with.offset(17);
            }
            make.bottom.lessThanOrEqualTo(self.contentView).with.offset(-10);
        }];
        
        TTTAttributedLabel *content = [TTTAttributedLabel new];
        content.numberOfLines = 0;
        content.textColor = UIColorFromRGB(0x666666);
        content.font = [UIFont systemFontOfSize:13];
        content.lineSpacing = 6;
        content.text = ((Notice *)notices[i]).content;
        lastView = content;
        [self.contentView addSubview:content];
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-10);
            make.top.equalTo(title.mas_bottom).with.offset(6);
            make.bottom.lessThanOrEqualTo(self.contentView).with.offset(-10);
        }];
    }
    
}

@end
