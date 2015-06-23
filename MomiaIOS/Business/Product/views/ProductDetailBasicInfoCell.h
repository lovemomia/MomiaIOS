//
//  ActivityDetailBasicInfo.h
//  MomiaIOS
//
//  Created by Owen on 15/6/16.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"
@class ProductModel;

@interface ProductDetailBasicInfoCell : MOTableCell<MOTableCellDataProtocol>

-(void)setData:(NSString *)data;

-(void)setData:(ProductModel *)model withIndex:(NSInteger) index;

@end
