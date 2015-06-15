//
//  FillOrderPersonCell.h
//  MomiaIOS
//
//  Created by Owen on 15/6/9.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"
typedef void(^ChooseBlock)(UIButton * sender);

@interface FillOrderPersonCell : MOTableCell<MOTableCellDataProtocol>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (nonatomic,strong) ChooseBlock chooseBlock;

@end
