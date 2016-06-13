//
//  PlaymateSuggestHeadCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/24.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"
#import "AvatarImageView.h"

@interface FeedSuggestHeadCell : MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet AvatarImageView *avatarIv;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

-(void)setData:(id)data;

@end
