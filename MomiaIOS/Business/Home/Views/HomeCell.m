//
//  HomeCell.m
//  MomiaIOS
//
//  Created by Owen on 15/6/11.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "HomeCell.h"
#import "HomeModel.h"
static NSString * identifier = @"CellHome";

@implementation HomeCell

+(instancetype)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath
{
    HomeCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    return cell;
}

+(void)registerCellWithTableView:(UITableView *)tableView
{
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass(self) bundle:nil] forCellReuseIdentifier:identifier];
}

+(CGFloat)heightWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath data:(HomeDataItem *)data
{
    return [tableView fd_heightForCellWithIdentifier:identifier cacheByIndexPath:indexPath configuration:^(HomeCell *cell) {
        cell.data = data;
    }];
}

-(void)setData:(HomeDataItem *) data
{
    self.imgView.image = [UIImage imageNamed:data.url];
    self.titleLabel.text = data.title;
    self.timeLabel.text = data.time;
    self.descLabel.text = data.desc;
    self.enrollmentLabel.text = [NSString stringWithFormat:@"%ld人报名",data.enrollmentNum];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",data.price];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
