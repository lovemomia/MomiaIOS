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
        if([view isKindOfClass:[TTTAttributedLabel class]]) {
            [view removeFromSuperview];
        }
    }
    
    TTTAttributedLabel *label = [TTTAttributedLabel new];
    label.numberOfLines = 0;
    label.textColor = UIColorFromRGB(0x333333);
    label.font = [UIFont systemFontOfSize:13];
    label.lineSpacing = 6;
    label.text = data;
    [self.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(10);
        make.top.equalTo(self.contentView).with.offset(10);
        make.bottom.equalTo(self.contentView).with.offset(-10);
        make.right.equalTo(self.contentView).with.offset(-10);
    }];
}

@end
