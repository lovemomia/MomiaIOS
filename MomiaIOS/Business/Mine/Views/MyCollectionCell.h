//
//  MyCollectionCell.h
//  MomiaIOS
//
//  Created by Owen on 15/5/29.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

/**
 *这个Cell作为推荐和收藏公用cell
 */

#import <UIKit/UIKit.h>
#import "FavouriteModel.h"
#import "MySuggestModel.h"

@interface MyCollectionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *picImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView withData:(id)data;

+ (CGFloat)height;

@end
