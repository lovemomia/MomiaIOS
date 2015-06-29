//
//  FillOrderTopCell.h
//  MomiaIOS
//
//  Created by Owen on 15/6/24.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"

@class FillOrderSkuModel;

@interface FillOrderTopCell : MOTableCell<MOTableCellDataProtocol>

-(void)setData:(FillOrderSkuModel *)model;

@end
