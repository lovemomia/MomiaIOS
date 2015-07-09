//
//  ProductPlayFellowHeaderView.h
//  MomiaIOS
//
//  Created by Owen on 15/7/7.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayFellowModel.h"
typedef void(^OnClickHeaderBlock)(UITapGestureRecognizer *);

@interface ProductPlayFellowHeaderView : UITableViewHeaderFooterView

@property(nonatomic,strong) OnClickHeaderBlock onClickHeaderBlock;

+(instancetype)headerWithTableView:(UITableView *)tableView;

+(void)registerHeaderWithTableView:(UITableView *)tableView;

-(void)setData:(PlayFellowDataModel *) model;

@end
