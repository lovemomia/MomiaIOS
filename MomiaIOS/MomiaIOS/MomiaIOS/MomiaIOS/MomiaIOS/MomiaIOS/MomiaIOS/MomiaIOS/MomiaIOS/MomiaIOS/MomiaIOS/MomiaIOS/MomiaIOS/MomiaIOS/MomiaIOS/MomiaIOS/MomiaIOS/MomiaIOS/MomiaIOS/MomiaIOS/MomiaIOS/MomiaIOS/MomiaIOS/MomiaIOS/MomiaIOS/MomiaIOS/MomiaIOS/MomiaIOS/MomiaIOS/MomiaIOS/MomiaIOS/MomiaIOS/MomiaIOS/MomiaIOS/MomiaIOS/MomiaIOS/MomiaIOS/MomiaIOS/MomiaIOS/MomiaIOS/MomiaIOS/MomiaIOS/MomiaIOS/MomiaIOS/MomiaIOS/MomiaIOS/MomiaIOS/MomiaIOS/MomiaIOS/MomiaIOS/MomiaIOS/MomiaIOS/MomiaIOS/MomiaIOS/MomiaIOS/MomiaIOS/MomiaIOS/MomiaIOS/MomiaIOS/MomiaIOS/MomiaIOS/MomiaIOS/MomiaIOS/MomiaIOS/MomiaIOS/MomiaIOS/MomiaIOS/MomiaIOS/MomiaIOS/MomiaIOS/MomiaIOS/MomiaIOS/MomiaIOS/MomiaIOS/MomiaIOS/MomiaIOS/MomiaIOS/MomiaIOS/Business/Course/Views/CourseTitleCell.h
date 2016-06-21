//
//  CourseTitleCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/11/23.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"

@interface CourseTitleCell : MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
