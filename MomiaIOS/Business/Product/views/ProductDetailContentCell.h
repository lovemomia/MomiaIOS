//
//  ProductDetailContentCell.h
//  MomiaIOS
//
//  Created by Owen on 15/7/2.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OnLinkBlock)(UIView * linkView);

@class ProductContentModel;

@interface ProductDetailContentCell : UITableViewCell

@property(nonatomic,strong) OnLinkBlock linkBlock;

-(instancetype)initWithTableView:(UITableView *) tableView contentModel:(ProductContentModel *)model;

+(CGFloat)heightWithTableView:(UITableView *) tableView contentModel:(ProductContentModel *)model;

@end
