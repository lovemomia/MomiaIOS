//
//  SkuItemCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/15.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "SkuItemCell.h"
#import "SkuListModel.h"
#import "StringUtils.h"

@implementation SkuItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(Sku *)data {
    self.titleLabel.text = [NSString stringWithFormat:@"¥%@元/组", [StringUtils stringForPrice:data.price]];
    self.descLabel.text = data.desc;
    self.stepperView.currentValue = [data.count intValue];
}

+ (CGFloat)heightWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath data:(id)data {
    return 60;
}

@end
