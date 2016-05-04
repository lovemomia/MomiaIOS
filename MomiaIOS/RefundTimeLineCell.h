//
//  RefundTimeLineCell.h
//  MomiaIOS
//
//  Created by mosl on 16/4/25.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOTableCell.h"

@interface RefundTimeLineCell: MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UILabel *applyTitle;
@property (weak, nonatomic) IBOutlet UILabel *applyDetail;
@property (weak, nonatomic) IBOutlet UILabel *applyTimeLabel;

- (void)setData:(id)data;

@end
