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

-(void)setData:(HomeDataItem *) data
{
    self.imgView.image = [UIImage imageNamed:data.url];
    self.titleLabel.text = data.title;
    self.timeLabel.text = data.time;
    self.descLabel.text = data.desc;
    self.enrollmentLabel.text = [NSString stringWithFormat:@"%ld人报名",data.enrollmentNum];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",data.price];
    
    [self.timeLabel setBackgroundColor:[UIColor redColor]];
    [self.enrollmentLabel setBackgroundColor:[UIColor blueColor]];
    
    self.firstImgWidthConstraint.constant = [self.timeLabel systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].width + 18;
    self.secondImgWidthConstraint.constant = [self.enrollmentLabel systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].width + 18;

}


- (void)awakeFromNib {
    // Initialization code
   
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
