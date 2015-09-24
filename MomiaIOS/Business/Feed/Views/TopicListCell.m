//
//  TopicListCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/9/24.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "TopicListCell.h"
#import "TopicListModel.h"

@implementation TopicListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(Topic *)data {
    self.titleLabel.text = data.title;
    self.dateLabel.text = data.scheduler;
    self.regionLabel.text = data.region;
}

@end
