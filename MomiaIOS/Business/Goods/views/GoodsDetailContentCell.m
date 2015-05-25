//
//  GoodsDetailContentCell.m
//  MomiaIOS
//
//  Created by Owen on 15/5/22.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "GoodsDetailContentCell.h"
static NSString * identifier = @"CellGoodsDetailContent";
#define contentFont [UIFont boldSystemFontOfSize:15.0f]

@implementation GoodsDetailContentCell

-(instancetype)init
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if(self) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor lightGrayColor];
        _contentLabel.font = contentFont;
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentLabel.superview.mas_top).with.offset(8);
            make.left.equalTo(_contentLabel.superview.mas_left).with.offset(8);
            make.bottom.equalTo(_contentLabel.superview.mas_bottom).with.offset(-8);
            make.right.equalTo(_contentLabel.superview.mas_right).with.offset(-8);
        }];
    }
    return self;
}

-(void)setStr:(NSString *)data
{
    self.contentLabel.text = data;
}


-(void)setData:(GoodsDetailData *)data
{
    self.contentLabel.text = data.abstracts;
}


+ (instancetype)cellWithTableView:(UITableView *)tableView withData:(GoodsDetailData *)data
{
    GoodsDetailContentCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil) {
        cell = [[GoodsDetailContentCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    cell.data = data;
    return cell;
    
}

+(CGFloat) textHeightWithString:(NSString *) data
{
    CGFloat height = 0;
    
    if(data) {
        CGRect textFrame = [UILabel heightForMutableString:data withWidth:(SCREEN_WIDTH - 16) andFont:contentFont];
        height += textFrame.size.height;
    }
    return height;
}

+(CGFloat) textHeightWithData:(GoodsDetailData *)data
{
    CGFloat height = 0;
    
    if(data.abstracts) {
        CGRect textFrame = [UILabel heightForMutableString:data.abstracts withWidth:(SCREEN_WIDTH - 16) andFont:contentFont];
        height += textFrame.size.height;
    }
    return height;
}

+ (CGFloat)heightWithData:(GoodsDetailData *)data
{
    CGFloat height = 0;
    
    height += 8;
    height += [GoodsDetailContentCell textHeightWithData:data];
    height += 8;
    height +=1;
   
    return height;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView withString:(NSString *)data
{
    GoodsDetailContentCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil) {
        cell = [[GoodsDetailContentCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    cell.str = data;
    return cell;

}

+ (CGFloat)heightWithString:(NSString *)data
{
    CGFloat height = 0;
    
    height += 8;
    height += [GoodsDetailContentCell textHeightWithString:data];
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
