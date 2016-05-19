//
//  OrderListItemFooterCell.h
//  MomiaIOS
//
//  Created by mosl on 16/5/4.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"

@interface OrderListItemFooterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet UILabel *totalFee;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;

@property (nonatomic, strong) Order *order;

- (void)setData:(Order *)order;

@end
