//
//  PlaymateUserHeadCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/22.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"

@interface PlaymateUserHeadCell : MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet UIImageView *avatarIv;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;


-(void)setData:(id)data;

@end
