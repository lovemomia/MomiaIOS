//
//  MOTableCell.m
//  MomiaIOS
//
//  Created by Owen on 15/6/15.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"

@implementation MOTableCell

+ (instancetype)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath withIdentifier:(NSString *) identifier {
    id cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    return cell;
}

+ (void)registerCellFromNibWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier {
     [tableView registerNib:[UINib nibWithNibName:NSStringFromClass(self) bundle:nil] forCellReuseIdentifier:identifier];
}

+ (void)registerCellFromClassWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier {
    [tableView registerClass:self forCellReuseIdentifier:identifier];
}

+ (CGFloat)heightWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath data:(id)data {
    return [tableView fd_heightForCellWithIdentifier:identifier cacheByIndexPath:indexPath configuration:^(MOTableCell * cell) {
        cell.data = data;
    }];
}

- (void)setData:(id)data {
    //do nothing, the subclass must implementation it
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
