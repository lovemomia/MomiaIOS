//
//  BuyCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/8.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "CourseBuyCell.h"
#import "Course.h"
#import "StringUtils.h"

@interface CourseBuyCell()

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceHeadLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceEndLabel;


@property (weak, nonatomic) IBOutlet UIButton *buyButton;

@end

@implementation CourseBuyCell

- (void)awakeFromNib {
    // Initialization code
    self.buyButton.layer.cornerRadius = 3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(Course *)data {
    Course *course = data;
    self.priceLabel.text = [StringUtils stringForPrice:course.price];
    
    if ([course.buyable intValue] == 1) {
        self.buyButton.enabled = YES;
        [self.buyButton setTitle:@"立即抢购" forState:UIControlStateNormal];
    } else {
        self.buyButton.enabled = NO;
        [self.buyButton setTitle:@"名额已满" forState:UIControlStateDisabled];
    }
}

+ (CGFloat)heightWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath data:(id)data {
    return 64;
}

@end
