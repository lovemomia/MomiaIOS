//
//  MyFavCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/23.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MyFavCell.h"
#import "StringUtils.h"

@interface MyFavCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
@implementation MyFavCell

- (void)awakeFromNib {
    // Initialization code
    self.iconImgView.layer.masksToBounds = YES;
    self.iconImgView.layer.cornerRadius = 3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(Course *) model {
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:nil];
    self.titleLabel.text = model.title;
    self.timeLabel.text = model.scheduler;
    self.addressLabel.text = model.region;
    self.priceLabel.text = [StringUtils stringForPrice:model.price];
}

@end
