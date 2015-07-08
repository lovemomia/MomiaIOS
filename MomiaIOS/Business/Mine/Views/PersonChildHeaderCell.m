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
    if (view == nil) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"PersonChildHeaderCell" owner:self options:nil];
        view = [arr objectAtIndex:0];
    }
    return view;
}

@end
