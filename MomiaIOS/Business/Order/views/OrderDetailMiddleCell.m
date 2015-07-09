//
//  OrderDetailMiddleCell.m
//  MomiaIOS
//
//  Created by Owen on 15/7/9.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "OrderDetailMiddleCell.h"

@interface OrderDetailMiddleCell ()
@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *enrollLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation OrderDetailMiddleCell

-(void)setData:(OrderDetailDataModel *)model
{
    self.orderNoLabel.text = [NSString stringWithFormat:@"%ld",model.orderNo];
    self.timeLabel.text = model.addTime;
    self.enrollLabel.text = model.participants;
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f",model.totalFee];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
