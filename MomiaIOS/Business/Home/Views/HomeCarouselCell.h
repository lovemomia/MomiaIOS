//
//  HomeCarouselCell.h
//  MomiaIOS
//
//  Created by Owen on 15/6/11.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"
@class HomeCarouselData;

@interface HomeCarouselCell : MOTableCell<MOTableCellDataProtocol>

+(CGFloat)heightWithTableView:(UITableView *)tableView;

@end
