//
//  OrderDetailTopCell.m
//  MomiaIOS
//
//  Created by Owen on 15/7/7.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "OrderDetailTopCell.h"

@interface OrderDetailTopCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation OrderDetailTopCell

- (void)awakeFromNib {
    // Initialization code
    self.iconImgView.layer.cornerRadius = 3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
