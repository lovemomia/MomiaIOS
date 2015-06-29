//
//  FillOrderTopCell.m
//  MomiaIOS
//
//  Created by Owen on 15/6/24.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "FillOrderTopCell.h"
#import "FillOrderModel.h"

@interface FillOrderTopCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation FillOrderTopCell

-(void)setData:(FillOrderSkuModel *)model;
{
    self.timeLabel.text = model.time;
    self.stockLabel.text = [NSString stringWithFormat:@"仅剩%ld个名额",model.stock];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f起",model.minPrice];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
