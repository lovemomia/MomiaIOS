//
//  PersonChildHeaderCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/6.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "PersonChildHeaderCell.h"
#import "MOStepperView.h"

static NSString * identifier = @"CellPersonChildHeader";

@interface PersonChildHeaderCell ()
@end

@implementation PersonChildHeaderCell


+(instancetype)cellWithTableView:(UITableView *)tableView
{
    PersonChildHeaderCell * view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    return view;
}

+(void)registerCellWithTableView:(UITableView *)tableView
{
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass(self) bundle:nil] forHeaderFooterViewReuseIdentifier:identifier];
}

@end
