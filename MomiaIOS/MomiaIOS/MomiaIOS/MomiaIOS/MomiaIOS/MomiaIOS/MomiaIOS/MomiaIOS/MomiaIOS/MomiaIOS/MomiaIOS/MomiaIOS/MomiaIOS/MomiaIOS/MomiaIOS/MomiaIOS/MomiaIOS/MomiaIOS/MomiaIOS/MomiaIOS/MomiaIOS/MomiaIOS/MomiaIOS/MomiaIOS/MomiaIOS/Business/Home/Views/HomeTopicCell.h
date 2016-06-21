//
//  HomeTopicCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 16/3/22.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"

@interface HomeTopicCell : MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end
