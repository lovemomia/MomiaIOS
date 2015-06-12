//
//  HomeCarouselCell.h
//  MomiaIOS
//
//  Created by Owen on 15/6/11.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeCarouselData;

@interface HomeCarouselCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath;

+(void)registerCellWithTableView:(UITableView *)tableView;

+(CGFloat)heightWithTableView:(UITableView *)tableView;

-(void)setData:(HomeCarouselData *) data;

@end
