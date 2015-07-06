//
//  PersonChildHeaderCell.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/6.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOStepperView.h"

@interface PersonChildHeaderCell : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet MOStepperView *stepperView;

+(instancetype)cellWithTableView:(UITableView *)tableView;

+(void)registerCellWithTableView:(UITableView *)tableView;

@end
