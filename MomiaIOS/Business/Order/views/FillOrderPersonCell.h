//
//  FillOrderPersonCell.h
//  MomiaIOS
//
//  Created by Owen on 15/6/9.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ChooseBlock)(UIButton * sender);

@interface FillOrderPersonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (nonatomic,strong) ChooseBlock chooseBlock;

+(instancetype)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath;

+(void)registerCellWithTableView:(UITableView *)tableView;

+(CGFloat)heightWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath data:(NSDictionary *)data;

-(void)setData:(NSDictionary *) dic;

@end
