//
//  MyCollectionCell.m
//  MomiaIOS
//
//  Created by Owen on 15/5/29.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MyCollectionCell.h"

static NSString * identifier = @"CellMyCollection";

@implementation MyCollectionCell


-(void)setFavouriteData:(FavouriteItem *)data
{
    [self.picImgView sd_setImageWithURL:[NSURL URLWithString:data.picUrl]];
    [self.timeLabel setText:data.time];
    [self.titleLabel setText:data.title];
    if(data.type == 0) {
        [self.typeLabel setText:@"文章"];
    } else if(data.type == 1) {
        [self.typeLabel setText:@"商品"];

    } else if(data.type == 2) {
        [self.typeLabel setText:@"文章专题"];

    } else {
        [self.typeLabel setText:@"商品专题"];
    }
}

-(void)setMySuggestData:(MysuggestItem *)data
{
    [self.picImgView sd_setImageWithURL:[NSURL URLWithString:data.picUrl]];
    [self.timeLabel setText:data.time];
    [self.titleLabel setText:data.title];
    [self.typeLabel setText:[data.assortments componentsJoinedByString:@" "]];
}


+ (instancetype)cellWithTableView:(UITableView *)tableView withData:(id)data
{
    MyCollectionCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"MyCollectionCell" owner:self options:nil];
        cell = [arr objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if([data isKindOfClass:[MysuggestItem class]])
        cell.mySuggestData = data;
    else if([data isKindOfClass:[FavouriteItem class]])
        cell.favouriteData= data;
    return cell;

}

+ (CGFloat)height
{
    return 106.0f;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
