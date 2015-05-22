//
//  GoodsTopicItemCell.h
//  MomiaIOS
//
//  Created by Owen on 15/5/21.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsTopicModel.h"

@interface GoodsTopicItemCell : UITableViewCell

@property(nonatomic,strong) UIImageView * numImgView;
@property(nonatomic,strong) UILabel * titleLabel;
@property(nonatomic,strong) UILabel * contentLabel;
@property(nonatomic,strong) UIImageView * photoImgView;
@property(nonatomic,strong) UILabel * priceLabel;
@property(nonatomic,strong) UIButton * detailBtn;

+ (instancetype)cellWithTableView:(UITableView *)tableView withData:(GoodsTopicItem *)data;

+ (CGFloat)height;
@end
