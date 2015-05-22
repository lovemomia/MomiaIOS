//
//  GoodsDetailHeaderCell.h
//  MomiaIOS
//
//  Created by Owen on 15/5/22.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailModel.h"

@interface GoodsDetailHeaderCell : UITableViewCell

@property (nonatomic, strong) UIImageView * photoImgView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic, strong) UIImageView * authorImgView;
@property (nonatomic, strong) UILabel * authorLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView withData:(GoodsDetailData *)data;

+ (CGFloat)height;
+ (CGFloat)coverHeight;


@end
