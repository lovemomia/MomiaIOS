//
//  OrderPersonCell.h
//  MomiaIOS
//
//  Created by Owen on 15/6/10.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"
#import "OrderPersonModel.h"

typedef void(^OnCheckBlock)(UIButton *);

@interface OrderPersonCell : MOTableCell

@property(nonatomic,strong) OnCheckBlock onCheckBlock;

-(void)setData:(OrderPersonDataModel *)model withSelectedDic:(NSDictionary *) selectedDic;

@end
