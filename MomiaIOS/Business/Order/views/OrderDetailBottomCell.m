//
//  OrderDetailBottomCell.m
//  MomiaIOS
//
//  Created by Owen on 15/7/9.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "OrderDetailBottomCell.h"

@interface OrderDetailBottomCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end

@implementation OrderDetailBottomCell


-(void)setData:(OrderDetailDataModel *) model
{
    self.nameLabel.text = model.contacts;
    self.phoneLabel.text = model.mobile;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
