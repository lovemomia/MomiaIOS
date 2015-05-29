//
//  GoodsDetailShopCell.m
//  MomiaIOS
//
//  Created by Owen on 15/5/22.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "GoodsDetailShopCell.h"
#import "GoodsDetailModel.h"

static NSString * identifier = @"CellGoodsDetailShop";

#define contentFont [UIFont systemFontOfSize:14.0f]

#define contentInsetsTop 12

@implementation GoodsDetailShopCell

-(instancetype)init
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if(self) {
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = MO_APP_VCBackgroundColor;
        
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
        
        [self.contentView addSubview:_lineView];
        [self.contentView addSubview:_shopLabel];
        [self.contentView addSubview:_priceLabel];
        [self.contentView addSubview:_contentLabel];
        [self.contentView addSubview:_buyBtn];
        
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_lineView.superview.mas_top).with.offset(0);
            make.left.equalTo(_lineView.superview.mas_left).with.offset(0);
            make.right.equalTo(_lineView.superview.mas_right).with.offset(0);
            make.height.equalTo(@1);
        
        }];
       
        
        [_shopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_shopLabel.superview.mas_top).with.offset(contentInsetsTop);
            make.left.equalTo(_shopLabel.superview.mas_left).with.offset(8);
            make.height.equalTo(@20);
            make.right.equalTo(_priceLabel.mas_left).with.offset(-3);
          
        }];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_shopLabel.mas_bottom).with.offset(contentInsetsTop);
            make.left.equalTo(_contentLabel.superview.mas_left).with.offset(8);
            make.bottom.equalTo(_contentLabel.superview.mas_bottom).with.offset(-contentInsetsTop);
            make.right.equalTo(_priceLabel.mas_left).with.offset(-3);

            
        }];
        
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@100);
            make.height.equalTo(@30);
            make.right.equalTo(_priceLabel.superview.mas_right).with.offset(-8);
            make.bottom.equalTo(_priceLabel.superview.mas_centerY).with.offset(-1);
        }];
        
        [_buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@100);
            make.height.equalTo(@30);
            make.right.equalTo(_buyBtn.superview.mas_right).with.offset(-8);
            make.top.equalTo(_buyBtn.superview.mas_centerY).with.offset(1);
        }];
        
        
    }
    return self;
}

-(void)setData:(GoodsDetailShopItem *)data
{
    self.shopLabel.text = data.name;
    self.priceLabel.text = [NSString stringWithFormat:@"%.2lf",data.price];
    self.contentLabel.text = data.desc;
    [self.buyBtn setTitle:@"购买" forState:UIControlStateNormal];
}


+(instancetype)cellWithTableView:(UITableView *)tableView withData:(GoodsDetailShopItem *)data
{
    GoodsDetailShopCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil) {
        cell = [[GoodsDetailShopCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    cell.data = data;
    return cell;
}

+(CGFloat)textHeightWithData:(GoodsDetailShopItem *)data
{
    CGFloat height = 0;
    
    if(data.desc) {
        CGRect textFrame = [UILabel heightForMutableString:data.desc withWidth:(SCREEN_WIDTH - 8 - 3 - 100 - 8)  lineSpace:MO_LABEL_LINE_SPACE andFont:contentFont];
        height += textFrame.size.height;
    }
    return height;
}

+ (CGFloat)heightWithData:(GoodsDetailShopItem *)data
{
    CGFloat height = 0;
    
    height += contentInsetsTop * 3;
    
    height += [GoodsDetailShopCell textHeightWithData:data];
    
    height += 20;
    
    height +=2;
    
    return height;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
