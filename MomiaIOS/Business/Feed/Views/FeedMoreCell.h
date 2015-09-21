//
//  FeedMoreCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/28.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"

@interface FeedMoreCell : MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

-(void)setData:(id)data;

@end
