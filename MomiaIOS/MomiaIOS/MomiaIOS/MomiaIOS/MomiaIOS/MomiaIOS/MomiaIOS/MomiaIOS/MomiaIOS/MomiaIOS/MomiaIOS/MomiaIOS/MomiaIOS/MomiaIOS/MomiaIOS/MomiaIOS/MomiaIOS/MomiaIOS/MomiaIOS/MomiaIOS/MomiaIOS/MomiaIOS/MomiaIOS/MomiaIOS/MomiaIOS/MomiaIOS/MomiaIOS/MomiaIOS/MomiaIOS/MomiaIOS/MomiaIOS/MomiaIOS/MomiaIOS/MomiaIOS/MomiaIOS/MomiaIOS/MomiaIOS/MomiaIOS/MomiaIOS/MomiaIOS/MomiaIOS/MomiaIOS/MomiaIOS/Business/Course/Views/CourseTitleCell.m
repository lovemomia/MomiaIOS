//
//  CourseTitleCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/11/23.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "CourseTitleCell.h"
#import "Course.h"

@implementation CourseTitleCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(Course *)data {
    self.titleLabel.text = data.title;
}

@end
