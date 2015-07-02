//
//  HomeCell.m
//  MomiaIOS
//
//  Created by Owen on 15/6/11.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "HomeCell.h"
#import "HomeModel.h"


@implementation HomeCell

-(void)setData:(ProductModel *) model;
{
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.titleLabel.text = model.title;
    [self.timeLabel setTitle:model.scheduler forState:UIControlStateNormal];
    self.descLabel.text = model.address;
    [self.enrollmentLabel setTitle:[NSString stringWithFormat:@"%d人报名", model.joined] forState:UIControlStateNormal];
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f", model.price];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
