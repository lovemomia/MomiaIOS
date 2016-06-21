//
//  CourseSectionTitleCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/10.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"

@interface CourseSectionTitleCell : MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end
