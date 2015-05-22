//
//  GoodsDetailImgCell.m
//  MomiaIOS
//
//  Created by Owen on 15/5/22.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "GoodsDetailImgCell.h"
#import "GoodsDetailModel.h"
static NSString * identifier = @"CellGoodsDetailImg";


@implementation GoodsDetailImgCell

-(instancetype)init
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if(self) {
        _photoImgView = [[UIImageView alloc] init];
     
        [self.contentView addSubview:_photoImgView];
        
        [_photoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_photoImgView.superview.mas_top).with.offset(8);
            make.left.equalTo(_photoImgView.superview.mas_left).with.offset(8);
            make.bottom.equalTo(_photoImgView.superview.mas_bottom).with.offset(-8);
            make.right.equalTo(_photoImgView.superview.mas_right).with.offset(-8);
        }];
    }
    return self;
}

-(void)setData:(GoodsDetailImgItem *)data
{
    [self.photoImgView sd_setImageWithURL:[NSURL URLWithString:data.url]];
}

+(CGFloat) imgHeightWithData:(GoodsDetailImgItem *)data
{
    CGFloat height = 0;
    if(data.url) {
        height = data.height * (SCREEN_WIDTH - 16.0)/data.width;
    }
    return height;
    
}

-(instancetype)cellWithTableView:(UITableView *)tableView withData:(GoodsDetailImgItem *)data
{
    GoodsDetailImgCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil) {
        cell = [[GoodsDetailImgCell alloc] init];
    }
    cell.data = data;
    return cell;
}

+ (CGFloat)heightWithData:(GoodsDetailImgItem *)data
{
    CGFloat height = 0;
    
    height += 8;
    
    height += [GoodsDetailImgCell imgHeightWithData:data];
    
    height += 8;
    
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
