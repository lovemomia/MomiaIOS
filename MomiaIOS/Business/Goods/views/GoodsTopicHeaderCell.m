//
//  GoodsTopicHeaderCell.m
//  MomiaIOS
//
//  Created by Owen on 15/5/21.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "GoodsTopicHeaderCell.h"

static NSString *identifier = @"CellGoods";

#define imgFactor 0.7

@implementation GoodsTopicHeaderCell

- (instancetype)init
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (self) {
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:16.0f];
        
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:21.0f]];
        
        UIImageView *titleMask = [[UIImageView alloc]init];
        titleMask.image = [UIImage imageNamed:@"bg_cover_mask"];
        
        _photoImgView = [[UIImageView alloc] init];
        [_photoImgView setContentMode:UIViewContentModeScaleAspectFill];
        
        [self.contentView addSubview:_photoImgView];
        [self.contentView addSubview:titleMask];
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_contentLabel];
        
        //设置布局
        
        [_photoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_photoImgView.superview.mas_top).with.offset(0);
            make.left.equalTo(_photoImgView.superview.mas_left).with.offset(0);
            make.width.equalTo(@SCREEN_WIDTH);
            make.height.equalTo(@(SCREEN_WIDTH * imgFactor));
        }];
        
        [titleMask mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.and.right.equalTo(_photoImgView);
            make.height.equalTo(@(64));
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_photoImgView.mas_left).with.offset(8);
            make.right.equalTo(_photoImgView.mas_right).with.offset(-8);
            make.bottom.equalTo(_photoImgView.mas_bottom).with.offset(-8);
            make.height.equalTo(@40);
        }];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentLabel.superview.mas_left).with.offset(8);
            make.right.equalTo(_contentLabel.superview.mas_right).with.offset(-8);
            make.bottom.equalTo(_contentLabel.superview.mas_bottom).with.offset(-8);
            make.top.equalTo(_photoImgView.mas_bottom).with.offset(8);
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

-(void)setData:(GoodsTopicData *)data
{
    [self.photoImgView sd_setImageWithURL:[NSURL URLWithString:data.topicPhoto]];
    [self.titleLabel setText:data.topicTitle];
    [self.contentLabel setText:data.abstracts];
}

+ (CGFloat)heightWithData:(GoodsTopicData *)data {
    
    CGFloat height = 0;//默认为零，但是不置为零，最开始会有问题，height会有值
    
    height += SCREEN_WIDTH * imgFactor;
    
    height += 8;
    
    height += [GoodsTopicHeaderCell textHeightWithData:data];
    
    height += 8;
    
    height +=1;
    
    return height;
}

+ (CGFloat)coverHeight
{
    return SCREEN_WIDTH * imgFactor;
}


+ (instancetype)cellWithTableView:(UITableView *)tableView withData:(GoodsTopicData *)data
{
    GoodsTopicHeaderCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil) {
        cell = [[GoodsTopicHeaderCell alloc] init];
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
