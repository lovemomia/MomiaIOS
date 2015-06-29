//
//  FillOrderMiddleCell.h
//  MomiaIOS
//
//  Created by Owen on 15/6/25.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"
#import "FillOrderModel.h"
#import "MOStepperView.h"

@interface FillOrderMiddleCell : MOTableCell
@property (weak, nonatomic) IBOutlet MOStepperView *stepperView;

-(void)setData:(FillOrderPriceModel *)model;

@end
