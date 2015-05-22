//
//  GoodsTopicHeaderCell.h
//  MomiaIOS
//
//  Created by Owen on 15/5/21.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsTopicModel.h"


@interface GoodsTopicHeaderCell : UITableViewCell

@property (nonatomic, strong) UIImageView * photoImgView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * contentLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView withData:(GoodsTopicData *)data;

+ (CGFloat)heightWithData:(GoodsTopicData *)data;

+ (CGFloat)coverHeight;

@end
