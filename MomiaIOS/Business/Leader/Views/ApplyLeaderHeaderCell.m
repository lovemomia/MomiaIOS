//
//  ApplyLeaderHeaderCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/30.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ApplyLeaderHeaderCell.h"

@implementation ApplyLeaderHeaderCell

- (void)awakeFromNib {
    // Initialization code
    [self.applyBtn setBackgroundImage:[UIImage imageNamed:@"BgLargeButtonNormal"] forState:UIControlStateNormal];
    [self.applyBtn setBackgroundImage:[UIImage imageNamed:@"BgLargeButtonDisable"] forState:UIControlStateDisabled];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
