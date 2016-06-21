//
//  GroupMemberItemCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/12/7.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "GroupMemberItemCell.h"
#import "User.h"

@implementation GroupMemberItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(User *)data {
    [self.avatarIv sd_setImageWithURL:[NSURL URLWithString:data.avatar] placeholderImage:[UIImage imageNamed:@"IconAvatarDefault"]];
    self.nameLabel.text = data.nickName;
}

@end
