//
//  UserInfoHeaderCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/11/13.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "UserInfoHeaderView.h"

@implementation UserInfoHeaderView

- (void)awakeFromNib {
    // Initialization code
}

- (void)setData:(User *)user {
    [self.backIv sd_setImageWithURL:[NSURL URLWithString:user.cover] placeholderImage:[UIImage imageNamed:@"BgUserInfo"]];
    [self.avatarIv sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"IconAvatarDefault"]];
    self.nameLabel.text = user.nickName;
    
    UIView *container = [[UIView alloc] init];
    [self addSubview:container];
    
    UIView *lastView;
    CGFloat totalWidth = 0;
    for (int i = 0; i < user.children.count; i++) {
        Child *child = user.children[i];
        UIImageView *icon = [[UIImageView alloc]init];
        [container addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@11);
            make.width.equalTo(@11);
            
            if (lastView) {
                make.left.equalTo(lastView.mas_right).with.offset(6);
            } else {
                make.left.equalTo(container);
            }
            make.top.equalTo(container).with.offset(2);
            make.bottom.equalTo(container).with.offset(-2);
        }];
        
        if ([child.sex isEqualToString:@"男"]) {
            icon.image = [UIImage imageNamed:@"IconBoy"];
        } else {
            icon.image = [UIImage imageNamed:@"IconGirl"];
        }
        totalWidth += 13;
        
        UILabel *age = [[UILabel alloc]init];
        [container addSubview:age];
        [age mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@15);
            
            make.left.equalTo(icon.mas_right).with.offset(3);
            make.top.equalTo(container).with.offset(0);
            make.bottom.equalTo(container).with.offset(0);
        }];
        lastView = age;
        
        age.textColor = [UIColor whiteColor];
        age.shadowColor = [UIColor darkGrayColor];
        age.shadowOffset = CGSizeMake(0, 1);
        age.font = [UIFont systemFontOfSize:12];
        age.text = [NSString stringWithFormat:@"%@%@",[child name], [child ageWithDateOfBirth]];
        CGSize size = [age.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:age.font,NSFontAttributeName, nil]];
        totalWidth += 6;
        totalWidth += size.width;
        
    }
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.equalTo([NSNumber numberWithFloat:totalWidth]);
        make.height.equalTo(@15);
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(3);
    }];
    
}

@end
