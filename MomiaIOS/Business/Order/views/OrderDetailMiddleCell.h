//
//  OrderDetailMiddleCell.h
//  MomiaIOS
//
//  Created by Owen on 15/7/9.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"
#import "OrderDetailModel.h"

@interface OrderDetailMiddleCell : MOTableCell<MOTableCellDataProtocol>

-(void)setData:(OrderDetailDataModel *)model;

@end
