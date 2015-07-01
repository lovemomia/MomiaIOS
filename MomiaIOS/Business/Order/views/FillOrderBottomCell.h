//
//  FillOrderBottomCell.h
//  MomiaIOS
//
//  Created by Owen on 15/6/25.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"
#import "FillOrderModel.h"

@interface FillOrderBottomCell : MOTableCell

-(void)setData:(FillOrderContactsModel *)model withIndex:(NSInteger)index andPersonStr:(NSString *)personStr;

@end
