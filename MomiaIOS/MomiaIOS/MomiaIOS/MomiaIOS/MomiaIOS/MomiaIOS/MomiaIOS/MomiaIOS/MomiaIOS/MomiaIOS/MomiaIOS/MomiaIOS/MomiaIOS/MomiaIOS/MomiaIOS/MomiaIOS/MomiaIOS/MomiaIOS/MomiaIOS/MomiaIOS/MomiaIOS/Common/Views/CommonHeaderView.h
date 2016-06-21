//
//  CommonHeaderView.h
//  MomiaIOS
//
//  Created by Owen on 15/6/18.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonHeaderView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cmLeadingConstraint;

+(instancetype)cellWithTableView:(UITableView *)tableView;

+(void)registerCellFromNibWithTableView:(UITableView *)tableView;

-(void)setData:(NSString *) title;

+(CGFloat)heightWithTableView:(UITableView *)tableView data:(NSString *)title;

@end
