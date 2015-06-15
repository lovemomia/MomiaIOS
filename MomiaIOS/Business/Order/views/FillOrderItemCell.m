//
//  FillOrderItemCell.m
//  MomiaIOS
//
//  Created by Owen on 15/6/8.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "FillOrderItemCell.h"

@implementation FillOrderItemCell

-(void)setData:(NSDictionary *) dic
{
    self.titleLabel.text = [dic objectForKey:@"title"];
    self.contentTextField.placeholder = [dic objectForKey:@"placeholder"];
}




#pragma mark - default override methods given by xcode

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
