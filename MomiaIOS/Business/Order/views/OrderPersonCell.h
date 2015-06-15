//
//  OrderPersonCell.h
//  MomiaIOS
//
//  Created by Owen on 15/6/10.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"

typedef void(^EditBlock)(UIButton * sender);
typedef void(^SelectBlock)(UIButton * sender);

@interface OrderPersonCell : MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthLabel;

@property(nonatomic,strong) EditBlock editBlock;
@property(nonatomic,strong) SelectBlock selectBlock;

@end
