//
//  FeedCommentCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/28.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "FeedCommentCell.h"

@implementation FeedCommentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(id)data {
    [self.avatarIv sd_setImageWithURL:@"" placeholderImage:[UIImage imageNamed:@"IconAvatarDefault"]];
}

@end
