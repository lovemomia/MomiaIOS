//
//  FeedTitleCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/27.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"

@interface FeedTitleCell : MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

-(void)setData:(id)data;

@end
