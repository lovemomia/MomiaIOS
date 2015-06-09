//
//  FillOrderItemCell.h
//  MomiaIOS
//
//  Created by Owen on 15/6/8.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FillOrderItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;

+(instancetype)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath;

+(void)registerCellWithTableView:(UITableView *)tableView;

+(CGFloat)heightWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath data:(NSDictionary *)data;

-(void)setData:(NSDictionary *) dic;

@end
