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
    self.timeLabel.text = model.scheduler;
    self.descLabel.text = model.address;
    self.enrollmentLabel.text = [NSString stringWithFormat:@"%ld人报名",model.joined];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",model.price];
    
    self.firstImgWidthConstraint.constant = [self.timeLabel systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].width + 6;
    self.secondImgWidthConstraint.constant = [self.enrollmentLabel systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].width + 6;

}


- (void)awakeFromNib {
    // Initialization code
   
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
