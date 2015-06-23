//
//  ActivityDetailLinkCell.h
//  MomiaIOS
//
//  Created by Owen on 15/6/18.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"

@class ProductContentModel;

@interface ProductDetailLinkCell : MOTableCell<MOTableCellDataProtocol>

-(void)setData:(ProductContentModel *)model;


@end
