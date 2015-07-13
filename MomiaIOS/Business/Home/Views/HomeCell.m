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
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:nil];
    self.titleLabel.text = model.title;
    [self.timeLabel setTitle:model.scheduler forState:UIControlStateNormal];
    self.descLabel.text = model.address;
    [self.enrollmentLabel setTitle:[NSString stringWithFormat:@"%ld人报名", model.joined] forState:UIControlStateNormal];
    self.priceLabel.text = [self stringForPrice:model.price];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString *)stringForPrice:(CGFloat)price {
    NSString *priceStr = [NSString stringWithFormat:@"%f", price];
    NSRange change = [priceStr rangeOfString:@".00"];
    if(change.length > 0) {
        return [NSString stringWithFormat:@"%d", (int)price];
    }
    return [NSString stringWithFormat:@"%.2f", price];
}

@end
