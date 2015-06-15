//
//  FillOrderItemCell.h
//  MomiaIOS
//
//  Created by Owen on 15/6/8.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"

@interface FillOrderItemCell : MOTableCell<MOTableCellDataProtocol>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;

@end
