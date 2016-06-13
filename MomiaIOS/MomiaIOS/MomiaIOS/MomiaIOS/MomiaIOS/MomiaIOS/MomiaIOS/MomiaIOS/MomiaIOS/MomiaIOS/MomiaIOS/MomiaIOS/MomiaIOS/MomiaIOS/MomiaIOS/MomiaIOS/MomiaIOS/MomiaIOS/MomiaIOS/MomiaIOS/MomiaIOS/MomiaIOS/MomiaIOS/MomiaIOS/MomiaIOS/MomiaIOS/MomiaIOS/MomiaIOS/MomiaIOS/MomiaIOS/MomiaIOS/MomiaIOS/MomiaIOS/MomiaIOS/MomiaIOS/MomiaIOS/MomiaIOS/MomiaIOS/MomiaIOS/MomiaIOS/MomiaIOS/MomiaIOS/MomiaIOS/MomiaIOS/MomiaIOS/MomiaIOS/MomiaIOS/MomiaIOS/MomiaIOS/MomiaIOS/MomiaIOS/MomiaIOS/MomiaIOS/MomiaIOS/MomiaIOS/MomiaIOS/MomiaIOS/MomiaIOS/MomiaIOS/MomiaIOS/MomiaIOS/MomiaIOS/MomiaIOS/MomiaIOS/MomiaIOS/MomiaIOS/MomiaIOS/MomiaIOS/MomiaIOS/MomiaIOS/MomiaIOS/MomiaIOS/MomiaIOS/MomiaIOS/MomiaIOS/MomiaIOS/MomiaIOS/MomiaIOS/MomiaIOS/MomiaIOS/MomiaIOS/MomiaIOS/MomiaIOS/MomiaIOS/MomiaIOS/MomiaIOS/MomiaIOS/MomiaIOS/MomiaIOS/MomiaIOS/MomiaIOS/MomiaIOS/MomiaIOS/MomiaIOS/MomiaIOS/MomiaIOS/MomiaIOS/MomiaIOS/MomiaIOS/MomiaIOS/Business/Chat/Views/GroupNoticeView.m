//
//  GroupNoticeView.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/12/14.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "GroupNoticeView.h"
#import "IMGroupModel.h"

@implementation GroupNoticeView

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(IMGroup *)data {
    self.timeLabel.text = data.time;
    self.addressLabel.text = data.address;
    self.routeLabel.text = data.route;
    self.tipsLabel.text = data.tips;
}

@end
