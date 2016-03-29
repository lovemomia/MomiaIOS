//
//  HomeTopicCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 16/3/22.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "HomeTopicCell.h"
#import "IndexModel.h"

@implementation HomeTopicCell

- (void)awakeFromNib {
    // Initialization code
    
    self.countLabel.layer.borderColor = [UIColorFromRGB(0x333333) CGColor];
    self.countLabel.layer.borderWidth = 1.0f;
    self.countLabel.layer.cornerRadius = 8.0;
    self.countLabel.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(IndexTopic *)data {
    self.titleLabel.text = data.title;
    self.subTitleLabel.text = data.subTitle;
    self.countLabel.text = [NSString stringWithFormat:@"  %@人在讨论  ", data.joined];
}

@end
