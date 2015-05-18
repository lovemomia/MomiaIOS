//
//  ArticleDetailContentCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/7.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ArticleDetailContentCell.h"
#import "Constants.h"
#import "Masonry.h"

@interface ArticleDetailContentCell()

@property (nonatomic, assign)BOOL hasGetWebHeight;


@end

@implementation ArticleDetailContentCell

- (void)awakeFromNib {
    // Initialization code

    [self.contentLabel setNumberOfLines:0];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(ArticleDetailContentItem *)data {
    
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.font = [UIFont systemFontOfSize:16.0f];
    self.contentLabel.text = data.text;
    [self.photoImageView setContentMode:UIViewContentModeScaleToFill];

    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:data.image]];


}

+ (instancetype)cellWithTableView:(UITableView *)tableView withData:(ArticleDetailContentItem *)data{
    static NSString *identifier = @"CellContent";
    ArticleDetailContentCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil) {
        cell = [[ArticleDetailContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.contentLabel = [[UILabel alloc] init];
        cell.photoImageView = [[UIImageView alloc] init];
        
        [cell.contentView addSubview:cell.contentLabel];
        [cell.contentView addSubview:cell.photoImageView];
        
    }
  

    if(data.text && !data.image) {//只有文字
     

        [cell.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.mas_top).with.offset(8);
            make.left.equalTo(cell.contentView.mas_left).with.offset(8);
            make.bottom.equalTo(cell.contentView.mas_bottom).with.offset(-8);
            make.right.equalTo(cell.contentView.mas_right).with.offset(-8);

        }];
        
        [cell.photoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        }];
       
        
    } else if(!data.text && data.image) {//只有图片
        [cell.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        }];
        [cell.photoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.mas_top).with.offset(8);
            make.left.equalTo(cell.contentView.mas_left).with.offset(8);
            make.bottom.equalTo(cell.contentView.mas_bottom).with.offset(-8);
            make.right.equalTo(cell.contentView.mas_right).with.offset(-8);
        }];
       
    } else {//图文混排
        NSLog(@"图文混排");
        [cell.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.mas_top).with.offset(8);
            make.left.equalTo(cell.contentView.mas_left).with.offset(8);
            make.bottom.equalTo(cell.photoImageView.mas_top).with.offset(-16);
            make.right.equalTo(cell.contentView.mas_right).with.offset(-8);
            
        }];
        [cell.photoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left).with.offset(8);
            make.bottom.equalTo(cell.contentView.mas_bottom).with.offset(-8);
            make.right.equalTo(cell.contentView.mas_right).with.offset(-8);
            make.height.equalTo(@170);
        }];
    }
    
    return cell;
}

+ (CGFloat)heightWithData:(ArticleDetailContentItem *)data {
    CGFloat height;
    
    if(data.text && !data.image) {//只有文字
        CGRect textFrame = [UILabel heightForMutableString:data.text withWidth:(SCREEN_WIDTH - 16) andFontSize:16.0];
        height += textFrame.size.height;
        height += 16;
            
    } else if(!data.text && data.image) {//只有图片
        
        height += 170;
        height +=16;
        
    } else {//图文混排
    
        height += 8;
        CGRect textFrame = [UILabel heightForMutableString:data.text withWidth:(SCREEN_WIDTH - 16) andFontSize:16.0];
        height += textFrame.size.height;
        
        height += 16;
        
        height += 170;
        
        height +=8;
        
    }
    return height;
}

@end
