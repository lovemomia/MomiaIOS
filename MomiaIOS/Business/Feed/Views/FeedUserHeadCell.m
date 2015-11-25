//
//  PlaymateUserHeadCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/22.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "FeedUserHeadCell.h"
#import "Feed.h"

@interface FeedUserHeadCell()
@property (nonatomic, strong) Feed *feed;
@end

@implementation FeedUserHeadCell

- (void)awakeFromNib {
    // Initialization code
    self.avatarIv.layer.masksToBounds = YES;
    self.avatarIv.layer.cornerRadius = self.avatarIv.width / 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(Feed *)data {
    self.feed = data;
    [self.avatarIv sd_setImageWithURL:[NSURL URLWithString:data.avatar] placeholderImage:[UIImage imageNamed:@"IconAvatarDefault"]];
    self.nameLabel.text = data.nickName;
    self.dateLabel.text = data.addTime;
    if (data.children && data.children.count > 0) {
        NSMutableString *ms = [[NSMutableString alloc] init];
        for (NSString *child in data.children) {
            [ms appendString:child];
            [ms appendString:@" "];
        }
        self.descLabel.text = ms;
    }
}

- (IBAction)onUserInfoClicked:(id)sender {
    if (self.feed) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"duola://userinfo?uid=%@", self.feed.userId]]];
    }
}

@end
