//
//  ActivityDetailContentCell.h
//  MomiaIOS
//
//  Created by Owen on 15/6/16.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"

@class ProductContentModel;

@interface ProductDetailContentCell : MOTableCell<MOTableCellDataProtocol>

-(void)setData:(ProductContentModel *)model;

@end
