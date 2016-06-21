//
//  SkuItemCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/15.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"
#import "MOStepperView.h"

@interface SkuItemCell : MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet MOStepperView *stepperView;

@property (nonatomic, assign) BOOL isPackage;

@end
