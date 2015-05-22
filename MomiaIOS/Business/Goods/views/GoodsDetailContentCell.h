//
//  GoodsDetailContentCell.h
//  MomiaIOS
//
//  Created by Owen on 15/5/22.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailModel.h"


@interface GoodsDetailContentCell : UITableViewCell

@property(nonatomic,strong) UILabel * contentLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView withData:(GoodsDetailData *)data;

+ (CGFloat)heightWithData:(GoodsDetailData *)data;

@end
