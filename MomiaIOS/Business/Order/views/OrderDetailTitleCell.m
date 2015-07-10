//
//  OrderDetailTitleCell.m
//  MomiaIOS
//
//  Created by Owen on 15/7/10.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "OrderDetailTitleCell.h"

@interface OrderDetailTitleCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation OrderDetailTitleCell

-(void)setData:(NSString *)data
{
    self.titleLabel.text = data;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
