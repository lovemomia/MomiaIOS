//
//  HomeCell.m
//  MomiaIOS
//
//  Created by Owen on 15/6/11.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "HomeCell.h"
#import "StringUtils.h"


@implementation HomeCell

-(void)setData:(Subject *) model;
{
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:nil];
    self.titleLabel.text = model.title;
    self.timeLabel.text = model.scheduler;
    self.descLabel.text = model.region;
    
    if ([model.joined intValue] == 0) {
        self.enrollmentLabel.hidden = YES;
        self.enrollmentBg.hidden = YES;
        
    } else {
        self.enrollmentLabel.hidden = NO;
        self.enrollmentBg.hidden = NO;
        self.enrollmentLabel.text = [NSString stringWithFormat:@"%@人参加", model.joined];
    }
    
    self.priceLabel.text = [StringUtils stringForPrice:model.price];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
