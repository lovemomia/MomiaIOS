//
//  FillOrderFooterView.m
//  MomiaIOS
//
//  Created by Owen on 15/6/9.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "FillOrderFooterView.h"

static NSString * identifier = @"FillOrderFooterViewIdentifier";

@implementation FillOrderFooterView

#pragma mark - methods added by Owen
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    FillOrderFooterView * cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    return cell;
}

+(void)registerCellWithTableView:(UITableView *)tableView
{
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass(self) bundle:nil] forHeaderFooterViewReuseIdentifier:identifier];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
