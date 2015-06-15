//
//  FillOrderPersonCell.m
//  MomiaIOS
//
//  Created by Owen on 15/6/9.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "FillOrderPersonCell.h"


@implementation FillOrderPersonCell
- (IBAction)onChooseClick:(id)sender {
    self.chooseBlock(sender);
}


-(void)setData:(NSDictionary *) dic
{
    self.titleLabel.text = [dic objectForKey:@"title"];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
