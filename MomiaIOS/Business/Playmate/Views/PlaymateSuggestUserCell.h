//
//  PlaymateSuggestUserCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/24.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"

@interface PlaymateSuggestUserCell : MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet UIImageView *avatarIv;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *babyLabel;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;

- (IBAction)onFollowClick:(id)sender;

-(void)setData:(id)data;

@end
