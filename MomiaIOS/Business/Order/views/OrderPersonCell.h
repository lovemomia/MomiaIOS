//
//  OrderPersonCell.h
//  MomiaIOS
//
//  Created by Owen on 15/6/10.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"
#import "OrderPersonModel.h"

@interface OrderPersonCell : MOTableCell<MOTableCellDataProtocol>

-(void)setData:(OrderPersonDataModel *)model;

@end
