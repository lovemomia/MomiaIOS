//
//  OrderAddPersonFillCell.h
//  MomiaIOS
//
//  Created by Owen on 15/6/25.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"
#import "AddPersonModel.h"

typedef void(^EditingChanged)(UITextField *);

@interface OrderAddPersonFillCell : MOTableCell

@property (nonatomic,strong) EditingChanged editingChanged;

-(void)setData:(AddPersonModel *)model withIndex:(NSInteger) index;

@end
