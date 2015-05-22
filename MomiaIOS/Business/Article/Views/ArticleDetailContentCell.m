//
//  ArticleDetailContentCell.m
//  MomiaIOS
//
//  Created by Owen on 15/5/18.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ArticleDetailContentCell.h"
#import "Constants.h"

static NSString *identifier = @"CellContent";


@interface ArticleDetailContentCell()

@property (nonatomic, assign)BOOL hasGetWebHeight;

@end

@implementation ArticleDetailContentCell

- (instancetype)init
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (self) {
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:16.0f];
        
        _photoImageView = [[UIImageView alloc] init];
        
        [self.contentView addSubview:_contentLabel];
        [self.contentView addSubview:_photoImageView];
        
    }
    return self;
}


- (void)setData:(ArticleDetailContentItem *)data {
    if(data.text && !data.image) {
        self.contentLabel.frame = CGRectMake(8, 8, SCREEN_WIDTH - 16, [ArticleDetailContentCell textHeightWithData:data]);
        self.contentLabel.text = data.text;
        self.photoImageView.frame = CGRectMake(0, 0, 0, 0);
        self.photoImageView.image = nil;
    } else if(!data.text && data.image) {
        self.contentLabel.frame = CGRectMake(0, 0, 0, 0);
        self.contentLabel.text = nil;
        self.photoImageView.frame = CGRectMake(8, 8, SCREEN_WIDTH - 16, [ArticleDetailContentCell imgHeightWithData:data]);
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:data.image.url]];
    } else {
        self.contentLabel.frame = CGRectMake(8, 8, SCREEN_WIDTH - 16, [ArticleDetailContentCell textHeightWithData:data]);
        self.contentLabel.text = data.text;
        self.photoImageView.frame = CGRectMake(8, 8 + self.contentLabel.bounds.size.height + 16, SCREEN_WIDTH - 16, [ArticleDetailContentCell imgHeightWithData:data]);
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:data.image.url]];
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView withData:(ArticleDetailContentItem *)data{
    
    ArticleDetailContentCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil) {
        cell = [[ArticleDetailContentCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    cell.data = data;
    return cell;
}

+(CGFloat) textHeightWithData:(ArticleDetailContentItem *)data
{
    CGFloat height = 0;
    
    if(data.text) {
        CGRect textFrame = [UILabel heightForMutableString:data.text withWidth:(SCREEN_WIDTH - 16) andFontSize:16.0];
        height += textFrame.size.height;
    }
    return height;
}


+(CGFloat) imgHeightWithData:(ArticleDetailContentItem *)data
{
    CGFloat height = 0;
    if(data.image) {
        height = data.image.height * (SCREEN_WIDTH - 16.0)/data.image.width;
        
    }
    return height;
    
}


+ (CGFloat)heightWithData:(ArticleDetailContentItem *)data {
    
    CGFloat height = 0;//默认为零，但是不置为零，最开始会有问题，height会有值
    
    if(data.text && !data.image) {//只有文字
        height += [ArticleDetailContentCell textHeightWithData:data];
        height += 16;
        
    } else if(!data.text && data.image) {//只有图片
        height += [ArticleDetailContentCell imgHeightWithData:data];
        height +=16;
        
    } else {//图文混排
        height += 8;
        height += [ArticleDetailContentCell textHeightWithData:data];
        
        height += 16;
        
        height += [ArticleDetailContentCell imgHeightWithData:data];
        
        height +=8;
        
    }
    return height;
}



@end

