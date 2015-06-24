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
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"home_carousel"]];
    self.titleLabel.text = model.title;
    [self.timeLabel setTitle:model.scheduler forState:UIControlStateNormal];
    self.descLabel.text = model.address;
    [self.enrollmentLabel setTitle:[NSString stringWithFormat:@"%ld人报名",model.joined] forState:UIControlStateNormal];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",model.price];
}


- (void)awakeFromNib {
    // Initialization code
    UIImage *image = [UIImage imageNamed:@"home_textbg"];
    image = [image stretchableImageWithLeftCapWidth:floorf(image.size.width/2) topCapHeight:floorf(image.size.height/2)];
    [self.timeLabel setBackgroundImage:image forState:UIControlStateDisabled];
    [self.enrollmentLabel setBackgroundImage:image forState:UIControlStateDisabled];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
