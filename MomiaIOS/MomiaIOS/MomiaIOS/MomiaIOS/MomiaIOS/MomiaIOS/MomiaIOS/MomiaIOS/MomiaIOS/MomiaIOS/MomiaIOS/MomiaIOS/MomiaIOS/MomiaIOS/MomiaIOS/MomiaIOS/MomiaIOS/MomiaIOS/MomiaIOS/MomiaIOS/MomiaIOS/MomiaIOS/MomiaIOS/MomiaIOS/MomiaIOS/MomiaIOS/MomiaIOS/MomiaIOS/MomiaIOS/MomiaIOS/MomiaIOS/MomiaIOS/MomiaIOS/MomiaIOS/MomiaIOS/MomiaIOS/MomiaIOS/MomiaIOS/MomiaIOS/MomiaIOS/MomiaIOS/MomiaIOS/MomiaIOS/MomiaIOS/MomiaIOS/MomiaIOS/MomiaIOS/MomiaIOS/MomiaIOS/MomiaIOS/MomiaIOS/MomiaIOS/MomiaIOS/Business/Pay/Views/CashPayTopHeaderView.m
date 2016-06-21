//
//  CashPayTopHeaderView.m
//  MomiaIOS
//
//  Created by Owen on 15/6/11.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "CashPayTopHeaderView.h"

static NSString * identifier = @"HeaderViewCashPayTop";

@implementation CashPayTopHeaderView


+(instancetype)headerViewWithTableView:(UITableView *)tableView
{
    return [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
}

+(void)registerHeaderViewWithTableView:(UITableView *)tableView
{
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass(self) bundle:nil] forHeaderFooterViewReuseIdentifier:identifier];
}

+(CGFloat)heightWithTableView:(UITableView *)tableView data:(NSDictionary *) data
{
    return [tableView fd_heightForHeaderViewWithIdentifier:identifier configuration:^(CashPayTopHeaderView * headerView) {
        headerView.data = data;
    }];
}

-(void)setData:(NSDictionary *) data
{
    self.titleLabel.text = [data objectForKey:@"title"];
    self.descLabel.text = [data objectForKey:@"desc"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
