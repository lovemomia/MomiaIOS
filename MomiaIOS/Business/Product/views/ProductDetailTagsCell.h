//
//  ProductDetailTagsCell.h
//  MomiaIOS
//
//  Created by Owen on 15/7/10.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"
#import "ProductModel.h"

@interface ProductDetailTagsCell : MOTableCell<MOTableCellDataProtocol>

-(void)setData:(ProductModel *)model;

@end
