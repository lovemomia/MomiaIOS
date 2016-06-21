//
//  FeedListItemCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/11/23.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"
#import "AvatarImageView.h"

@interface FeedListItemCell : MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet AvatarImageView *avatarIv;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIView *childContainer;

@property (weak, nonatomic) IBOutlet UIView *containerView;

- (IBAction)onUserInfoClicked:(id)sender;

@end
