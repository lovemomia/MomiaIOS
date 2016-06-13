//
//  OrderContactCell.h
//  MomiaIOS
//
//  Created by Owen on 15/7/1.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"
#import "FillOrderModel.h"

typedef void(^EditingChanged)(UITextField *);


@interface OrderContactCell : MOTableCell

@property (nonatomic,strong) EditingChanged editingChanged;

-(void)setData:(FillOrderContactsModel *)model withIndex:(NSInteger) index;

@end
