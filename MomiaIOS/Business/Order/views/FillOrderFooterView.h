//
//  FillOrderFooterView.h
//  MomiaIOS
//
//  Created by Owen on 15/6/9.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FillOrderFooterView : UITableViewHeaderFooterView

+(instancetype)cellWithTableView:(UITableView *)tableView;

+(void)registerCellWithTableView:(UITableView *)tableView;

@end
