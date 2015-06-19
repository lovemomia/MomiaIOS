//
//  HomeCarouselCell.h
//  MomiaIOS
//
//  Created by Owen on 15/6/11.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"

@interface HomeCarouselCell : MOTableCell<MOTableCellDataProtocol>

@property (nonatomic,strong) void(^scrollClick)(NSInteger index);

+(CGFloat)heightWithTableView:(UITableView *)tableView;

-(void)setData:(NSArray *) banners;

@end
