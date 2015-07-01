//
//  OrderAddPersonFillCell.h
//  MomiaIOS
//
//  Created by Owen on 15/6/25.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"
#import "UpdatePersonModel.h"

typedef void(^EditingChanged)(UITextField *);

@interface OrderUpdatePersonFillCell : MOTableCell

@property (nonatomic,strong) EditingChanged editingChanged;

-(void)setData:(UpdatePersonModel *)model withIndex:(NSInteger) index;

@end
