//
//  OrderPersonCell.h
//  MomiaIOS
//
//  Created by Owen on 15/6/10.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"
#import "OrderPerson.h"

typedef void(^OnCheckBlock)(UIButton *);

@interface OrderPersonCell : MOTableCell

@property(nonatomic,strong) OnCheckBlock onCheckBlock;

-(void)setData:(OrderPerson *)model withSelectedDic:(NSDictionary *) selectedDic;

@end
