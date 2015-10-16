//
//  BuyCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/8.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "CourseBuyCell.h"
#import "Package.h"
#import "StringUtils.h"

@interface CourseBuyCell()

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;

@property (nonatomic, strong) Package *data;

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

- (void)setData:(Package *)data {
    _data = data;
    self.priceLabel.text = [StringUtils stringForPrice:data.price];
    
    NSString *oldPrice = [StringUtils stringForPrice:data.originalPrice];
    NSUInteger length = [oldPrice length] + 1;
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@", oldPrice]];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:UIColorFromRGB(0x999999) range:NSMakeRange(0, length)];
    [self.oldPriceLabel setAttributedText:attri];
}

+ (CGFloat)heightWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath data:(id)data {
    return 64;
}

@end
