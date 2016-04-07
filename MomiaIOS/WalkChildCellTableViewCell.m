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
    
    self.child = child;
    [_name setText:child.name];
    [_sex setText:child.sex];
    [_age setText:[child ageWithDateOfBirth]];
    if (child.avatar) {
        NSURL *url = [[NSURL alloc]initWithString:child.avatar];
        [_avatar sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [_avatar setImage:image];
        }];
    }
}

- (IBAction)editChildDetail:(id)sender {
    
    ChildDetailViewController *childDetailVC = [[ChildDetailViewController alloc]initWithParams:@{@"action":@"update",@"childId":self.child.ids}];
    [_ownerVC.navigationController pushViewController:childDetailVC animated:YES];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
