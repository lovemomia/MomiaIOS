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

-(void)setData:(OrderPerson *)model withSelectedDic:(NSDictionary *) selectedDic
{
    self.nameLabel.text = model.name;
    self.typeLabel.text = model.type;
    self.sexLabel.text = model.sex;
    if([selectedDic objectForKey:@(model.opId)]) {
        self.checkBtn.selected = YES;
    } else {
        self.checkBtn.selected = NO;
    }
}

-(void)onCheckClick:(UIButton *) checkBtn
{
    if(!checkBtn.selected) {
        checkBtn.selected = YES;
    } else {
        checkBtn.selected = NO;
    }
    self.onCheckBlock(checkBtn);

}


-(void)awakeFromNib
{
    
    [self.checkBtn setImage:[UIImage imageNamed:@"cm_circle_checked"] forState:UIControlStateSelected];
    [self.checkBtn setImage:[UIImage imageNamed:@"cm_circle_uncheck"] forState:UIControlStateNormal];
    [self.checkBtn addTarget:self action:@selector(onCheckClick:) forControlEvents:UIControlEventTouchUpInside];
}


@end
