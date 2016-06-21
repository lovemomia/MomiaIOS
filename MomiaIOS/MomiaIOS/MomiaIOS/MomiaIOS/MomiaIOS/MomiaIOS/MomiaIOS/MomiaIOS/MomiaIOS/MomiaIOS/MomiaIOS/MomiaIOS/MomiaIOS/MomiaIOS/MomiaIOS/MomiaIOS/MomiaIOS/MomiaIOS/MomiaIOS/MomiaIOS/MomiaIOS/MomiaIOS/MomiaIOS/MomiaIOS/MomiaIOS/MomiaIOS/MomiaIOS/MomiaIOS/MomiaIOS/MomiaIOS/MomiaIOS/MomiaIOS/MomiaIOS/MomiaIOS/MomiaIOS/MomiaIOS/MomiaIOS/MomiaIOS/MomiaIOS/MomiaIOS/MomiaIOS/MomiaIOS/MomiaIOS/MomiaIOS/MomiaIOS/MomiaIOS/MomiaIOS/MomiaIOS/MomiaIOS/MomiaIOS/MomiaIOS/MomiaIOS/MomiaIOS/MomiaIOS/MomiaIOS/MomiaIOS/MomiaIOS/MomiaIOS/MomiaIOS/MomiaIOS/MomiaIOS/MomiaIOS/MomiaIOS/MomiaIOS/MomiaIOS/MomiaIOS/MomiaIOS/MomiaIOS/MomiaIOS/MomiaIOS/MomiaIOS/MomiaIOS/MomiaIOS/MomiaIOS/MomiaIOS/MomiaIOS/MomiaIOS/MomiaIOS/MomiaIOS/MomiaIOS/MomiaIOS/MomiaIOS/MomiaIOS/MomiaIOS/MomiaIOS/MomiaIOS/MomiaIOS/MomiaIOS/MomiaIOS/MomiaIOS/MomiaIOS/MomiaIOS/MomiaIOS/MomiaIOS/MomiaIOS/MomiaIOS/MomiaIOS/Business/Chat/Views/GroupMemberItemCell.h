//
//  GroupMemberItemCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/12/7.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"
#import "AvatarImageView.h"

@interface GroupMemberItemCell : MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet AvatarImageView *avatarIv;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end
