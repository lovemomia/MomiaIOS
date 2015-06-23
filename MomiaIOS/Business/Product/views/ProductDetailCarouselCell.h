//
//  ActivityDetailCarouselCell.h
//  MomiaIOS
//
//  Created by Owen on 15/6/16.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"
@class ProductModel;

@interface ProductDetailCarouselCell : MOTableCell<MOTableCellDataProtocol>

-(void)setData:(ProductModel *)model;

@end
