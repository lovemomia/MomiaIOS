//
//  ProductPlayFellowCell.h
//  MomiaIOS
//
//  Created by Owen on 15/7/7.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"
#import "PlayFellowModel.h"

@interface ProductPlayFellowCell : MOTableCell<MOTableCellDataProtocol>

-(void)setData:(PlayFellowCustomersModel *) model;

@end
