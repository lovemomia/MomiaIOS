//
//  CashPayTopCell.m
//  MomiaIOS
//
//  Created by Owen on 15/6/10.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "CashPayTopCell.h"

static NSString * identifier = @"CellCashPay";

@implementation CashPayTopCell

#pragma mark - methods added by Owen
+(instancetype)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath
{
    CashPayTopCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    return cell;
}

+(void)registerCellWithTableView:(UITableView *)tableView
{
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass(self) bundle:nil] forCellReuseIdentifier:identifier];
}

+(CGFloat)heightWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath data:(NSDictionary *)data
{
    return [tableView fd_heightForCellWithIdentifier:identifier cacheByIndexPath:indexPath configuration:^(CashPayTopCell *cell) {
        cell.data = data;
    }];
}

-(void)setData:(NSDictionary *) dic
{
    self.titleLabel.text = [dic objectForKey:@"title"];
    self.priceLabel.text = [dic objectForKey:@"price"];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
