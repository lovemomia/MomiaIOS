//
//  GoodsDetailShopCell.h
//  MomiaIOS
//
//  Created by Owen on 15/5/22.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsDetailShopItem;

@interface GoodsDetailShopCell : UITableViewCell

@property(nonatomic,strong) UIView * lineView;
@property(nonatomic,strong) UILabel * shopLabel;
@property(nonatomic,strong) UILabel * contentLabel;
@property(nonatomic,strong) UILabel * priceLabel;
@property(nonatomic,strong) UIButton * buyBtn;

+(instancetype)cellWithTableView:(UITableView *)tableView withData:(GoodsDetailShopItem *)data;

+ (CGFloat)heightWithData:(GoodsDetailShopItem *)data;

@end
