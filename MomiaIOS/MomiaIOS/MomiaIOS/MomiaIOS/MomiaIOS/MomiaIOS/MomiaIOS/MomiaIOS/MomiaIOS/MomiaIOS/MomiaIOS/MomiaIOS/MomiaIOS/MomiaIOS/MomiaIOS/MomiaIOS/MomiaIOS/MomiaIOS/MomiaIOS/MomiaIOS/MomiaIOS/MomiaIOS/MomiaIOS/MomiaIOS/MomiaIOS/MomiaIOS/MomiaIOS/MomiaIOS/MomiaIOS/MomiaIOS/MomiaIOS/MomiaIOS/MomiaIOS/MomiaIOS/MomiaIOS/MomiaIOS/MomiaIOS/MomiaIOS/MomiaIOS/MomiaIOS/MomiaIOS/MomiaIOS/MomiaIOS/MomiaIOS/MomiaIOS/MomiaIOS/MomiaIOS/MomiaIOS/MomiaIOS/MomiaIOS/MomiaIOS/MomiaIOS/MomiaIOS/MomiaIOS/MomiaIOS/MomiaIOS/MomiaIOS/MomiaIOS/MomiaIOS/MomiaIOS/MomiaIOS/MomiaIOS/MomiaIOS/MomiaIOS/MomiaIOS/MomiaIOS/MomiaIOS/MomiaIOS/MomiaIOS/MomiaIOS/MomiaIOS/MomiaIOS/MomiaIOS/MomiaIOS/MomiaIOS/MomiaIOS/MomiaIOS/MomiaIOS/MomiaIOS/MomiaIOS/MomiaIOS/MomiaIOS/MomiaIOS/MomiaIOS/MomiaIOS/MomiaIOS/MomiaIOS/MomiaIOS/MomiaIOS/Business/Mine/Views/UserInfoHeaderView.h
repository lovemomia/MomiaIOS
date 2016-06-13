//
//  UserInfoHeaderCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/11/13.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AvatarImageView.h"
#import "User.h"

@interface UserInfoHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet AvatarImageView *avatarIv;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backIv;

- (void)setData:(User *)user;

@end
