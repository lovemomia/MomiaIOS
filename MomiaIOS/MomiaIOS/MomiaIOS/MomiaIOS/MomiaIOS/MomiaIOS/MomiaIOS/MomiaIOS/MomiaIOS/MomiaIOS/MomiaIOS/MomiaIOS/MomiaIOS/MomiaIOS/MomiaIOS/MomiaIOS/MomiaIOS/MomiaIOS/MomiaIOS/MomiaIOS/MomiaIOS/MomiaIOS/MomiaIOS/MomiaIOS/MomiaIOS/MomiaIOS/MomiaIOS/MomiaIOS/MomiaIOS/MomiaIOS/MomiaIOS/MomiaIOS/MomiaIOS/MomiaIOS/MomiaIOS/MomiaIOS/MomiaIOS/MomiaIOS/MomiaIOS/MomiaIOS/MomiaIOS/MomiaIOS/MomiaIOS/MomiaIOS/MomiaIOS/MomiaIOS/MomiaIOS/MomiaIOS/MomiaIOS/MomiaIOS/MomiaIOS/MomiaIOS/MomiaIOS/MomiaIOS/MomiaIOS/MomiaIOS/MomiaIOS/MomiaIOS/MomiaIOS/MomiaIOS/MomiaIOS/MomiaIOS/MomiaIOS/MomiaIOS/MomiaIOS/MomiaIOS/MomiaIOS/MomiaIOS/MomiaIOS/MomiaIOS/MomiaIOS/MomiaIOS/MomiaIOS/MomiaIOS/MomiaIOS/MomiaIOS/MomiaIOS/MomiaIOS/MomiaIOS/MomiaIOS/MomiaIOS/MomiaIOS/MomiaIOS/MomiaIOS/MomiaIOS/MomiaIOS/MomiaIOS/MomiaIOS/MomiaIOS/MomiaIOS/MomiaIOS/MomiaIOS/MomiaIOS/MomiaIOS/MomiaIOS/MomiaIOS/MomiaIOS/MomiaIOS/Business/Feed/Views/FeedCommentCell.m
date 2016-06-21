//
//  FeedCommentCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/28.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "FeedCommentCell.h"
#import "FeedDetailModel.h"


@implementation FeedCommentCell

- (void)awakeFromNib {
    // Initialization code
    self.avatarIv.layer.masksToBounds = YES;
    self.avatarIv.layer.cornerRadius = 19;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(FeedComment *)data {
    [self.avatarIv sd_setImageWithURL:[NSURL URLWithString:data.avatar] placeholderImage:[UIImage imageNamed:@"IconAvatarDefault"]];
    [self.nameLabel setText:data.nickName];
    [self.commentLabel setText:data.content];
    [self.dateLabel setText:data.addTime];
}

@end
