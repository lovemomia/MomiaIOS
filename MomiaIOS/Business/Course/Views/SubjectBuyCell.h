//
//  SubjctBuyCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/11/24.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"

@interface SubjectBuyCell : MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

@property (weak, nonatomic) IBOutlet UILabel *chooseLabel;

@end
