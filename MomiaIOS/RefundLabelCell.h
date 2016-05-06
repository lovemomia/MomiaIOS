//
//  RefundLabelCell.h
//  MomiaIOS
//
//  Created by mosl on 16/4/25.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOTableCell.h"

@interface RefundLabelCell: MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet UILabel *refundTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *refundDetailTextLabel;

- (void)setData:(id)data;
@end
