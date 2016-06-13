//
//  CoursePriceCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/14.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"

@interface CoursePriceCell : MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *tagsContainer;


@property (weak, nonatomic) IBOutlet UILabel *price1Label;
@property (weak, nonatomic) IBOutlet UILabel *price2Label;
@property (weak, nonatomic) IBOutlet UILabel *price3Label;

@end
