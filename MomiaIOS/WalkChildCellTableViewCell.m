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
    
}

- (IBAction)editChildDetail:(id)sender {
    
    ChildDetailViewController *childDetailVC = [[ChildDetailViewController alloc]init];
    [_ownerVC.navigationController pushViewController:childDetailVC animated:YES];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
