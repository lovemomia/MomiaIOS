//
//  ProductCalendarCell.h
//  MomiaIOS
//
//  Created by Owen on 15/7/16.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"
#import "ProductCalendarModel.h"

@interface ProductCalendarCell : MOTableCell<MOTableCellDataProtocol>

-(void)setData:(ProductModel *)model;

@end
