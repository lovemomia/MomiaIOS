//
//  PlaymateSuggestUserCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/24.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "PlaymateSuggestUserCell.h"

@implementation PlaymateSuggestUserCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.followBtn.layer setMasksToBounds:YES];
    [self.followBtn.layer setCornerRadius:2.0]; //设置矩圆角半径
    [self.followBtn.layer setBorderWidth:1.0];   //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = [UIColorFromRGB(0xF67531) CGColor];
    [self.followBtn.layer setBorderColor:colorref];//边框颜色
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onFollowClick:(id)sender {
}

-(void)setData:(id)data {
    [self.avatarIv sd_setImageWithURL:@"" placeholderImage:[UIImage imageNamed:@"IconAvatarDefault"]];
}


@end
