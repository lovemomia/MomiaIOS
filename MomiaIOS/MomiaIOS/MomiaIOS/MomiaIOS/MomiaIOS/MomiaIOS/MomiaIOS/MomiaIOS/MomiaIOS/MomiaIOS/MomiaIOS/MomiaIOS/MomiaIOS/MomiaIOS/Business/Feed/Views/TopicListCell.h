//
//  TopicListCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/9/24.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"

@interface TopicListCell : MOTableCell<MOTableCellDataProtocol>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *regionLabel;

-(void)setData:(id)data;

@end
