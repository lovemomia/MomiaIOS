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
@synthesize childContainer;

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
    
    for (UIView * view in childContainer.subviews) {
        if([view isKindOfClass:[UILabel class]] || [view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    UIView *lastView;
    for (int i = 0; i < data.childrenDetail.count; i++) {
        FeedChild *child = data.childrenDetail[i];
        UIImageView *icon = [[UIImageView alloc]init];
        [childContainer addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@11);
            make.width.equalTo(@11);
            
            if (lastView) {
                make.left.equalTo(lastView.mas_right).with.offset(6);
            } else {
                make.left.equalTo(childContainer);
            }
            make.top.equalTo(childContainer).with.offset(2);
            make.bottom.equalTo(childContainer).with.offset(-2);
        }];
        
        if ([child.sex isEqualToString:@"男"]) {
            icon.image = [UIImage imageNamed:@"IconBoy"];
        } else {
            icon.image = [UIImage imageNamed:@"IconGirl"];
        }
        
        UILabel *age = [[UILabel alloc]init];
        [childContainer addSubview:age];
        [age mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@15);
            
            make.left.equalTo(icon.mas_right).with.offset(3);
            make.top.equalTo(childContainer).with.offset(0);
            make.bottom.equalTo(childContainer).with.offset(0);
        }];
        lastView = age;
        
        age.textColor = UIColorFromRGB(0x666666);
        age.font = [UIFont systemFontOfSize:12];
        age.text = [NSString stringWithFormat:@"%@ %@",[child name], [child age]];
    }
}

- (IBAction)onUserInfoClicked:(id)sender {
    if (self.feed && !self.disableUserInfoClick) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"duola://userinfo?uid=%@", self.feed.userId]]];
    }
}

@end
