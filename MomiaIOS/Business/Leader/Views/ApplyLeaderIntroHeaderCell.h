//
//  ApplyLeaderIntroHeaderCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/30.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"

@interface ApplyLeaderIntroHeaderCell : MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

-(void)setData:(id)data;

@end
