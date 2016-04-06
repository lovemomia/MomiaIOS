//
//  WalkChildCellTableViewCell.m
//  MomiaIOS
//
//  Created by mosl on 16/4/5.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "WalkChildCellTableViewCell.h"
#import "ChildDetailViewController.h"

@implementation WalkChildCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

-(void)setData:(Child *)child{
    
    [_name setText:child.name];
    [_sex setText:child.sex];
    [_age setText:[child ageWithDateOfBirth]];
    
}

- (IBAction)editChildDetail:(id)sender {
    
    ChildDetailViewController *childDetailVC = [[ChildDetailViewController alloc]initWithParams:@{@"action":@"update",@"childid":@123}];
    [_ownerVC.navigationController pushViewController:childDetailVC animated:YES];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
