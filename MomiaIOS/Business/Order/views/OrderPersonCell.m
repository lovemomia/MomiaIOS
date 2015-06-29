//
//  OrderPersonCell.m
//  MomiaIOS
//
//  Created by Owen on 15/6/10.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "OrderPersonCell.h"

@interface OrderPersonCell ()
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;

@end

@implementation OrderPersonCell

-(void)setData:(OrderPersonDataModel *)model
{
    self.nameLabel.text = model.name;
    self.typeLabel.text = model.type;
    self.sexLabel.text = model.sex;
}


-(void)awakeFromNib
{
    
    [self.checkBtn setImage:[UIImage imageNamed:@"orderperson_circle_checked"] forState:UIControlStateSelected];
    [self.checkBtn setImage:[UIImage imageNamed:@"orderperson_circle_uncheck"] forState:UIControlStateNormal];
}


@end
