//
//  SelectSkuCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/8/4.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"
#import "LeaderSkuModel.h"

@interface SelectSkuCell : MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *leaderInfoLabel;

-(void)setData:(LeaderSku *) model;

@end
