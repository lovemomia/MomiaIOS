//
//  GoodsDetailImgCell.h
//  MomiaIOS
//
//  Created by Owen on 15/5/22.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsDetailImgItem;

@interface GoodsDetailImgCell : UITableViewCell

@property(nonatomic,strong) UIImageView * photoImgView;

-(instancetype)cellWithTableView:(UITableView *)tableView withData:(GoodsDetailImgItem *)data;

+ (CGFloat)heightWithData:(GoodsDetailImgItem *)data;


@end
