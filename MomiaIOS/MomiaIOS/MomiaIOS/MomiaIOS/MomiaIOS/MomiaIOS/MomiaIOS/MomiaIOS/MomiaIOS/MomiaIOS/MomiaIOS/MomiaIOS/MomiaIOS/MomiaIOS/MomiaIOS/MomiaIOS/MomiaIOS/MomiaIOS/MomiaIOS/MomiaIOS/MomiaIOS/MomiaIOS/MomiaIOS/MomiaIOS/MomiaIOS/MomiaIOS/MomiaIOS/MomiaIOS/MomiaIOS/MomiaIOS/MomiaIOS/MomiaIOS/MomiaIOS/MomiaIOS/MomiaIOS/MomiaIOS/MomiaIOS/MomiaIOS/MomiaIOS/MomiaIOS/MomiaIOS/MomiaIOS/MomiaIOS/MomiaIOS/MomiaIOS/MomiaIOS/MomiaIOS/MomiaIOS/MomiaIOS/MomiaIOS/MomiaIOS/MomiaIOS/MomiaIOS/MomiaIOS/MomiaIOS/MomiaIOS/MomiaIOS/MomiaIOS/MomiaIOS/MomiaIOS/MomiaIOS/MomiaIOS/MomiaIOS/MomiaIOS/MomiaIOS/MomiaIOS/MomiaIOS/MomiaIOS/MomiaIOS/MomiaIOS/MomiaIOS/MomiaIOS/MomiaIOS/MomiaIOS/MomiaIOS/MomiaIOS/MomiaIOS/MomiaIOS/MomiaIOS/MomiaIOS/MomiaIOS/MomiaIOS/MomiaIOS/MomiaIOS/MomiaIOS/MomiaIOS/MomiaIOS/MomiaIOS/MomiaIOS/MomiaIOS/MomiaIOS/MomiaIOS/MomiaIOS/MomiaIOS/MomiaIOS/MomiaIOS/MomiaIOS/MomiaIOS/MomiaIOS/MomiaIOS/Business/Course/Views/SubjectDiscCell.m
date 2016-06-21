//
//  SubjectDiscCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 16/3/24.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "SubjectDiscCell.h"
#import "TTTAttributedLabel.h"
#import "Subject.h"

@implementation SubjectDiscCell

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
    
    TTTAttributedLabel *label = [TTTAttributedLabel new];
    label.numberOfLines = 0;
    label.textColor = UIColorFromRGB(0x666666);
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
