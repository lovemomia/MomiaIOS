//
//  HomeCell.m
//  MomiaIOS
//
//  Created by Owen on 15/6/11.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "HomeCell.h"
#import "HomeModel.h"
#import "StringUtils.h"


@implementation HomeCell

-(void)setData:(ProductModel *) model;
{
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:nil];
    self.titleLabel.text = model.title;
    self.timeLabel.text = model.scheduler;
    self.descLabel.text = model.address;
    self.enrollmentLabel.titleLabel.text = [NSString stringWithFormat:@"%ld人报名", model.joined];
//    [self.enrollmentLabel setTitle:[NSString stringWithFormat:@"%ld人报名", model.joined] forState:UIControlStateNormal];
    self.priceLabel.text = [StringUtils stringForPrice:model.price];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
