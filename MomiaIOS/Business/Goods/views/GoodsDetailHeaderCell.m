//
//  GoodsDetailHeaderCell.m
//  MomiaIOS
//
//  Created by Owen on 15/5/22.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "GoodsDetailHeaderCell.h"

#define imgFactor 0.7

#define priceInsetsTop 10


static NSString * identifier = @"CellGoodsDetailHeader";

@implementation GoodsDetailHeaderCell

- (instancetype)init
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (self) {
        
        _photoImgView = [[UIImageView alloc] init];
        [_photoImgView setContentMode:UIViewContentModeScaleAspectFill];
        
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:21.0f]];
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = [UIColor redColor];
        _priceLabel.font = [UIFont boldSystemFontOfSize:25.0f];
        
        _authorImgView = [[UIImageView alloc] init];

        _authorLabel = [[UILabel alloc] init];
        _authorLabel.textColor = [UIColor lightGrayColor];
        _authorLabel.font = [UIFont systemFontOfSize:14.0f];
        
        [self.contentView addSubview:_photoImgView];
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_priceLabel];
        [self.contentView addSubview:_authorImgView];
        [self.contentView addSubview:_authorLabel];
        
        //设置布局
        
        [_photoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_photoImgView.superview.mas_top).with.offset(0);
            make.left.equalTo(_photoImgView.superview.mas_left).with.offset(0);
            make.width.equalTo(@SCREEN_WIDTH);
            make.height.equalTo(@(SCREEN_WIDTH * imgFactor));
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_photoImgView.mas_left).with.offset(8);
            make.right.equalTo(_photoImgView.mas_right).with.offset(-8);
            make.bottom.equalTo(_photoImgView.mas_bottom).with.offset(-8);
            make.height.equalTo(@40);
        }];
        
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_photoImgView.mas_bottom).with.offset(priceInsetsTop);
            make.left.equalTo(_priceLabel.superview.mas_left).with.offset(8);
            make.bottom.equalTo(_priceLabel.superview.mas_bottom).with.offset(-priceInsetsTop);
            make.right.equalTo(_authorImgView.mas_left).with.offset(-8);
        }];
        
        [_authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_photoImgView.mas_bottom).with.offset(priceInsetsTop);
            make.bottom.equalTo(_authorLabel.superview.mas_bottom).with.offset(-priceInsetsTop);
            make.right.equalTo(_authorLabel.superview.mas_right).with.offset(-8);
            make.width.equalTo(@60);
        }];
        
        [_authorImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@40);
            make.top.equalTo(_photoImgView.mas_bottom).with.offset(priceInsetsTop);
            make.bottom.equalTo(_authorImgView.superview.mas_bottom).with.offset(-priceInsetsTop);
            make.right.equalTo(_authorLabel.mas_left).with.offset(-3);
        }];
        
    }
    return self;
}

-(void)setData:(GoodsDetailData *)data
{
    [self.photoImgView sd_setImageWithURL:[NSURL URLWithString:data.coverPhoto]];
    [self.titleLabel setText:data.title];
    [self.priceLabel setText:[NSString stringWithFormat:@"%f",data.price]];
    [self.authorImgView sd_setImageWithURL:[NSURL URLWithString:data.authorIcon]];
    [self.authorLabel setText:data.author];
}



+ (instancetype)cellWithTableView:(UITableView *)tableView withData:(GoodsDetailData *)data
{
    GoodsDetailHeaderCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil) {
        cell = [[GoodsDetailHeaderCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    cell.data = data;
    return cell;
}

+ (CGFloat)height{
    
    CGFloat height = 0;//默认为零，但是不置为零，最开始会有问题，height会有值
    
    height += SCREEN_WIDTH * imgFactor;
    height += priceInsetsTop;
    height += 40;
    height += priceInsetsTop;
    
    return height;
}


+ (CGFloat)coverHeight
{
    return SCREEN_WIDTH * imgFactor;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
