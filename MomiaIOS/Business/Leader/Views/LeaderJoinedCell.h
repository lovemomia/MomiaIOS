//
//  LeaderJoinedCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/8/3.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"
#import "ProductModel.h"

@interface LeaderJoinedCell : MOTableCell<MOTableCellDataProtocol>

-(void)setData:(ProductModel *) model;

@end
