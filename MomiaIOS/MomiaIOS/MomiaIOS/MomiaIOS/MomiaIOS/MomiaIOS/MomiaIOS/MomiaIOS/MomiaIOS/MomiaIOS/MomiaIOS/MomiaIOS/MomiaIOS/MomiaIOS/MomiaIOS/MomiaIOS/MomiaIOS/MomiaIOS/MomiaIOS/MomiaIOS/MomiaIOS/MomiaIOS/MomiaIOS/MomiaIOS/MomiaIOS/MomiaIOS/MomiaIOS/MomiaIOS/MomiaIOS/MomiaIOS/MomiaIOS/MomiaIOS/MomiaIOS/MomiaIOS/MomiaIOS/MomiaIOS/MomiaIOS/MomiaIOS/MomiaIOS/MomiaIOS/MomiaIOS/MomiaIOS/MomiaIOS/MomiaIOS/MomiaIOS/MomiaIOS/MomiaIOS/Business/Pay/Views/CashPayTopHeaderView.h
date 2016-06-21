//
//  CashPayTopHeaderView.h
//  MomiaIOS
//
//  Created by Owen on 15/6/11.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CashPayTopHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;

+(instancetype)headerViewWithTableView:(UITableView *)tableView;

+(void)registerHeaderViewWithTableView:(UITableView *)tableView;

+(CGFloat)heightWithTableView:(UITableView *)tableView data:(NSDictionary *) data;

-(void)setData:(NSDictionary *) data;

@end
