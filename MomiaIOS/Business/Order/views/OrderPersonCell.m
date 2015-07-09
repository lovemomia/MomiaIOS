//
//  OrderPersonCell.m
//  MomiaIOS
//
//  Created by Owen on 15/6/10.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "OrderPersonCell.h"

@interface OrderPersonCell ()


@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;

@end

@implementation OrderPersonCell

-(void)setData:(OrderPerson *)model withSelectedDic:(NSDictionary *) selectedDic
{
    self.nameLabel.text = model.name;
    self.typeLabel.text = model.type;
    self.sexLabel.text = model.sex;
    if([selectedDic objectForKey:@(model.opId)]) {
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

-(void)onEditClick:(UIButton *) editBtn
{
    self.onEditBlock(editBtn);
}


-(void)awakeFromNib
{
    [self.editBtn addTarget:self action:@selector(onEditClick:) forControlEvents:UIControlEventTouchUpInside];
}


@end
