//
//  FillOrderPersonCell.m
//  MomiaIOS
//
//  Created by Owen on 15/6/9.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "FillOrderPersonCell.h"

static NSString * identifier = @"CellFillOrderPerson";

@implementation FillOrderPersonCell

#pragma mark - methods added by Owen
+(instancetype)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath
{
    FillOrderPersonCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    return cell;
}

+(void)registerCellWithTableView:(UITableView *)tableView
{
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass(self) bundle:nil] forCellReuseIdentifier:identifier];
}

+(CGFloat)heightWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath data:(NSDictionary *)data
{
    return [tableView fd_heightForCellWithIdentifier:identifier cacheByIndexPath:indexPath configuration:^(FillOrderPersonCell *cell) {
        cell.data = data;
    }];
}

-(void)setData:(NSDictionary *) dic
{
    self.titleLabel.text = [dic objectForKey:@"title"];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
