//
//  OrderPersonCell.m
//  MomiaIOS
//
//  Created by Owen on 15/6/10.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "OrderPersonCell.h"
static NSString * identifier = @"CellOrderPerson";

@implementation OrderPersonCell

-(void)setData:(NSDictionary *)dic
{
    self.nameLabel.text = [dic objectForKey:@"name"];
    self.sexLabel.text = [dic objectForKey:@"sex"];
    self.birthLabel.text = [dic objectForKey:@"birth"];
}

+(CGFloat)heightWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath data:(NSDictionary *)dic
{
    return [tableView fd_heightForCellWithIdentifier:identifier cacheByIndexPath:indexPath configuration:^(OrderPersonCell *cell) {
        cell.data = dic;
    }];
}

+(instancetype)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath
{
    OrderPersonCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    return cell;
}

+(void)registerCellWithTableView:(UITableView *)tableView
{
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass(self) bundle:nil] forCellReuseIdentifier:identifier];
}

- (IBAction)onEditClick:(id)sender {
    self.editBlock(sender);
}

- (IBAction)onSelectClick:(id)sender {
    self.selectBlock(sender);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
