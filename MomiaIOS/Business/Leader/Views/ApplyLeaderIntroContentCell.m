//
//  ApplyLeaderIntroContentCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/30.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ApplyLeaderIntroContentCell.h"

@implementation ApplyLeaderIntroContentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(id)data {
    self.contentLabel.text = data;
}

@end
