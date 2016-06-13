//
//  PackageHeaderCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/11/24.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"

@interface PackageHeaderCell : MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet UILabel *packageNameLabel;

@end
