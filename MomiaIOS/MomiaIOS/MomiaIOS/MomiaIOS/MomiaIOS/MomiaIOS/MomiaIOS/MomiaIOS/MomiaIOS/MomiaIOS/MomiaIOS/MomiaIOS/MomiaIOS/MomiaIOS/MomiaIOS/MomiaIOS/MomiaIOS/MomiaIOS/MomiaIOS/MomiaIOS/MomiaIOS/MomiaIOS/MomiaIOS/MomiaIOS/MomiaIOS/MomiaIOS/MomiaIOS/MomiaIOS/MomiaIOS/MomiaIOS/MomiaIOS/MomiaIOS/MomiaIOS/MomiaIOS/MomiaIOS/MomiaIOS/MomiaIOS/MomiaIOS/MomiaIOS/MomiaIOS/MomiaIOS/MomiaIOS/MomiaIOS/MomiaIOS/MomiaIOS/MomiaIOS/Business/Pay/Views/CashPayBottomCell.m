//
//  CashPayBottomCell.m
//  MomiaIOS
//
//  Created by Owen on 15/6/10.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "CashPayBottomCell.h"
static NSString * identifier = @"CellCashPayBottom";

@implementation CashPayBottomCell

-(void)setData:(PayChannel *)payChannel
{
    self.payImgView.image = [UIImage imageNamed:payChannel.icon];
    self.payLabel.text = payChannel.title;
    self.descLabel.text = payChannel.desc;
    self.selectBtn.selected = payChannel.select;
}

- (void)awakeFromNib {
    // Initialization code
    [self.selectBtn setImage:[UIImage imageNamed:@"IconChecked"] forState:UIControlStateSelected];
    [self.selectBtn setImage:[UIImage imageNamed:@"IconUncheck"] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected animated:NO];

    // Configure the view for the selected state
}

@end
