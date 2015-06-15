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


-(void)setData:(NSDictionary *) dic
{
    self.payImgView.image = [dic objectForKey:@"image"];
    self.payLabel.text = [dic objectForKey:@"pay"];
    self.descLabel.text = [dic objectForKey:@"desc"];
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
