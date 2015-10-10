//
//  CommonHeaderView.m
//  MomiaIOS
//
//  Created by Owen on 15/6/18.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "CommonHeaderView.h"

static NSString * identifier = @"CellCommonIdentifier";

@interface CommonHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation CommonHeaderView


+(instancetype)cellWithTableView:(UITableView *)tableView
{
    CommonHeaderView * view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    return view;
}

+(void)registerCellFromNibWithTableView:(UITableView *)tableView
{
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass(self) bundle:nil] forHeaderFooterViewReuseIdentifier:identifier];
}

+(CGFloat)heightWithTableView:(UITableView *)tableView data:(NSString *)title
{
    return [tableView fd_heightForHeaderViewWithIdentifier:identifier configuration:^(CommonHeaderView * headerView) {
        headerView.data = title;
    }];
}


-(void)setData:(NSString *) title
{
    [self.titleLabel setText:title];
}

- (void)awakeFromNib {
    // Initialization code
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
