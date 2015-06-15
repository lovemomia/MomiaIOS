//
//  OrderPersonCell.m
//  MomiaIOS
//
//  Created by Owen on 15/6/10.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "OrderPersonCell.h"

@implementation OrderPersonCell

-(void)setData:(NSDictionary *)dic
{
    self.nameLabel.text = [dic objectForKey:@"name"];
    self.sexLabel.text = [dic objectForKey:@"sex"];
    self.birthLabel.text = [dic objectForKey:@"birth"];
}


- (IBAction)onEditClick:(id)sender {
    self.editBlock(sender);
}

- (IBAction)onSelectClick:(id)sender {
    self.selectBlock(sender);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
