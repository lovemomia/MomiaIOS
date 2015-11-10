//
//  MyFavCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/23.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"
#import "Course.h"

@interface MyFavCell : MOTableCell<MOTableCellDataProtocol>

-(void)setData:(Course *) model;

@end
