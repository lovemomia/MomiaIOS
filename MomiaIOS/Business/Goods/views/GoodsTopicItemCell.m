//
//  GoodsTopicItemCell.m
//  MomiaIOS
//
//  Created by Owen on 15/5/21.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "GoodsTopicItemCell.h"
static NSString * identifier = @"CellGoodsItem";
#define imageFactor 0.7

#define titleInsetTop 20
#define contentInsetTop 20
#define imgInsetTop 20
#define btnInsetTop 25





@implementation GoodsTopicItemCell

-(instancetype)init{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (self) {
        _numImgView = [[UIImageView alloc] init];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:21];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 2;
        _contentLabel.font = [UIFont systemFontOfSize:16.0f];
        
        _photoImgView = [[UIImageView alloc] init];
        _priceLabel = [[UILabel alloc] init];
        _detailBtn = [[UIButton alloc] init];
        [_detailBtn setBackgroundImage:[UIImage imageNamed:@"goodsrounct"] forState:UIControlStateNormal];
        [_detailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_detailBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:21]];

        
        [self.contentView addSubview:_numImgView];
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_contentLabel];
        [self.contentView addSubview:_photoImgView];
        [self.contentView addSubview:_priceLabel];
        [self.contentView addSubview:_detailBtn];

        
        [_numImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_numImgView.superview.mas_top).with.offset(titleInsetTop);
            make.left.equalTo(_numImgView.superview.mas_left).with.offset(8);
            make.width.equalTo(@30);
            make.height.equalTo(@30);
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLabel.superview.mas_top).with.offset(titleInsetTop);
            make.left.equalTo(_numImgView.mas_right).with.offset(10);
            make.right.equalTo(_titleLabel.superview.mas_right).with.offset(-8);
            make.height.equalTo(@30);
        }];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLabel.mas_bottom).with.offset(contentInsetTop);
            make.left.equalTo(_contentLabel.superview.mas_left).with.offset(8);
            make.right.equalTo(_contentLabel.superview.mas_right).with.offset(-8);
            make.height.equalTo(@50);
        }];
        
        [_photoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentLabel.mas_bottom).with.offset(imgInsetTop);
            make.left.equalTo(_photoImgView.superview.mas_left).with.offset(8);
            make.right.equalTo(_photoImgView.superview.mas_right).with.offset(-8);
            make.height.equalTo(@(SCREEN_WIDTH * imageFactor));
        }];
        
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_photoImgView.mas_bottom).with.offset(30);
            make.left.equalTo(_priceLabel.superview.mas_left).with.offset(8);
            make.width.equalTo(@100);
            make.height.equalTo(@30);
        }];
        
        [_detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_photoImgView.mas_bottom).with.offset(btnInsetTop);
            make.right.equalTo(_detailBtn.superview.mas_right).with.offset(-8);
            make.width.equalTo(@120);
            make.height.equalTo(@40);
        }];
        
    }
    
    return self;
    
}

+(CGFloat) textHeightWithData:(GoodsTopicData *)data
{
    CGFloat height = 0;
    
    if(data.abstracts) {
        CGRect textFrame = [UILabel heightForMutableString:data.abstracts withWidth:(SCREEN_WIDTH - 16) andFontSize:16.0];
        height += textFrame.size.height;
    }
    return height;
}

-(void)setData:(GoodsTopicItem *)data
{
    [self.photoImgView sd_setImageWithURL:[NSURL URLWithString:data.photo]];
    [self.titleLabel setText:data.title];
    [self.contentLabel setText:data.abstracts];
    [self.numImgView setImage:[UIImage imageNamed:@"goodsnum"]];
    [self.priceLabel setText:[NSString stringWithFormat:@"%f",data.price]];
    [self.detailBtn setTitle:@"查看详情" forState:UIControlStateNormal];
    
}

+ (CGFloat)height{
    
    CGFloat height = 0;//默认为零，但是不置为零，最开始会有问题，height会有值
    
    height += titleInsetTop;
    height += 30;
    
    height += contentInsetTop;
    height += 50;
    
    height += imgInsetTop;
    height += SCREEN_WIDTH * imageFactor;
    
    height += btnInsetTop;
    height += 40;
    
    height += 20;
    
    return height;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView withData:(GoodsTopicItem *)data
{
    GoodsTopicItemCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil) {
        cell = [[GoodsTopicItemCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    cell.data = data;
    return cell;
}




- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
