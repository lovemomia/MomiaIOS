//
//  GoodsDetailShopCell.m
//  MomiaIOS
//
//  Created by Owen on 15/5/22.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "GoodsDetailShopCell.h"

static NSString * identifier = @"CellGoodsDetailShop";

#define contentFont [UIFont boldSystemFontOfSize:14.0f]

#define contentInsetsTop 12

@implementation GoodsDetailShopCell

-(instancetype)init
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if(self) {
        _shopLabel = [[UILabel alloc] init];
        _shopLabel.textColor = [UIColor blackColor];
        _shopLabel.font = [UIFont systemFontOfSize:18.0f];
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = [UIColor redColor];
        _priceLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor lightGrayColor];
        _contentLabel.font = contentFont;
        _contentLabel.numberOfLines = 0;
        
        _buyBtn = [[UIButton alloc] init];
        [_buyBtn setBackgroundImage:[UIImage imageNamed:@"goodsrounct"] forState:UIControlStateNormal];
        [_buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buyBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:21]];
        
        [self.contentView addSubview:_shopLabel];
        [self.contentView addSubview:_priceLabel];
        [self.contentView addSubview:_contentLabel];
        [self.contentView addSubview:_buyBtn];
        
        [_shopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_shopLabel.superview.mas_top).with.offset(contentInsetsTop);
            make.left.equalTo(_shopLabel.superview.mas_left).with.offset(8);
            make.height.equalTo(@24);
          
        }];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_shopLabel.mas_bottom).with.offset(contentInsetsTop);
            make.left.equalTo(_shopLabel.mas_left).with.offset(0);
            make.bottom.equalTo(_contentLabel.superview.mas_bottom).with.offset(-contentInsetsTop);
            
        }];
        
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@100);
            make.height.equalTo(@30);
            make.right.equalTo(_priceLabel.superview.mas_right).with.offset(-8);
            make.top.equalTo(_priceLabel.superview);
        }];
        
        [_buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@100);
            make.height.equalTo(@30);
        }];
        
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
